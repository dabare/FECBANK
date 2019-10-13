import {AfterViewInit, Component, Input, OnChanges} from '@angular/core';
import {FinanceService} from '../../utils/finance.service';
import {NotificationsService} from '../../../../utils/notifications';
import Swal from 'sweetalert2';
import {CustomerLoanTimelineService} from './customer-loan-timeline.service';

declare var $: any;
declare var jQuery: any;

@Component({
  selector: 'app-customer-loan-timeline',
  templateUrl: './customer-loan-timeline.component.html',
  styleUrls: ['./customer-loan-timeline.component.scss']
})
export class CustomerLoanTimelineComponent implements OnChanges {

  loanStatus = {
    0: 'Cancelled',
    1: 'Active',
    2: 'Completed'
  };

  @Input()
  loanId: number;

  @Input()
  customerName: string;

  @Input()
  loan = {
    id: -1,
    code: '-',
    member_id: '',
    member_loan_plan_id: '-1',
    rate: '1',
    amount: '0.0',
    charges: '0.0',
    duration_months: 0,
    grace_period_days: 0,
    late_payment_charge: '0.0',
    reject_cheque_penalty: '0.0',
    status: '1',
    note: '',
    req_date: '',
    user_set_req_date: null,
    req_user: '-1',
    updated_by: '',
    rental: '',
    interest: '',
    total: ''
  };

  loanDeposit = {
    id: -1,
    member_loan_id: this.loan.id,
    amount: '0.0',
    status: '1',
    note: '',
    req_date: '',
    user_set_req_date: null,
    req_user: '-1'
  };


  deposits: any[] = [];

  actionMode = '';

  customerLoanTimelineDatatableLength = -1;
  customerLoanTimelineDatatableSearch = '';
  customerLoanTimelineDatatable: any;

  constructor(public financeService: FinanceService,
              private customerLoanTimelineService: CustomerLoanTimelineService,
              private notifi: NotificationsService) {
  }


  ngOnChanges() {
    this.loan.id = this.loanId;
    this.getInfoLoan();
  }

  getInfoLoan() {
    this.actionMode = 'info';
    this.deposits = [];
    this.customerLoanTimelineService.getDepositsOfLoan(this.loan).subscribe((data: any) => {
        this.deposits = this.financeService.processLoanHistory(data, this.loan.req_date,
          Number(this.loan.amount) * 100,
          Number(this.loan.duration_months),
          Number(this.loan.rate),
          Number(this.loan.rental) * 100,
          Number(this.loan.total) * 100,
          0);
        this.drawTable();
      }, (err) => {
        this.notifi.error('While fetching data');
      }
    );
  }

  clickDeleteLoanDeposit(i) {
    this.actionMode = 'delete';
    const currentClass = this;
    Swal.fire({
      title: 'Are you sure?',
      text: 'Cancel ' + this.financeService.getDepositCode(this.deposits[i - 1].id),
      type: 'warning',
      showCancelButton: true,
      confirmButtonClass: 'btn-danger',
      confirmButtonText: 'Yes, delete!'
    }).then(
      (willDelete) => {
        if (willDelete.value) {
          currentClass.loanDeposit.id = currentClass.deposits[i - 1].id;
          currentClass.customerLoanTimelineService.cancelMemberLoanDeposit(this.loanDeposit).subscribe((data: any) => {
              currentClass.getInfoLoan();
              currentClass.notifi.success('Deposit Cancelled');
            }, (err) => {
              currentClass.notifi.error('While Cancelling Deposit');
            }
          );
        }
      });
  }

  clickCompleteLoanDeposit() {
    this.actionMode = 'delete';
    const currentClass = this;
    Swal.fire({
      title: 'Are you sure?',
      text: 'Cancel ' + this.financeService.getLoanCode(this.loan.id),
      type: 'warning',
      showCancelButton: true,
      confirmButtonClass: 'btn-danger',
      confirmButtonText: 'Yes, complete!'
    }).then(
      (willDelete) => {
        if (willDelete.value) {
          currentClass.customerLoanTimelineService.completeMemberLoanDeposit(this.loan).subscribe((data: any) => {
              currentClass.getInfoLoan();
              currentClass.loan.status = '2';
              currentClass.notifi.success('Loan Completed');
            }, (err) => {
              currentClass.notifi.error('While Updating Loan');
            }
          );
        }
      });
  }

  clearLoanDeposit() {
    const today = new Date();

    this.loanDeposit.member_loan_id = this.loan.id;
    this.loanDeposit.amount = '0.0';
    this.loanDeposit.status = '1';
    this.loanDeposit.note = '-';
    this.loanDeposit.req_date = '';
    this.loanDeposit.req_user = '-1';

    this.loanDeposit.user_set_req_date = today;
  }

  clickNewLoanDeposit() {
    this.actionMode = 'new';
    this.clearLoanDeposit();
    $('#new_LoanDeposit').modal({backdrop: 'static', keyboard: false});
  }

  clickRegisterLoanDeposit() {
    this.loanDeposit.req_date = this.loanDeposit.user_set_req_date.year + '-' + this.loanDeposit.user_set_req_date.month + '-'
      + this.loanDeposit.user_set_req_date.day;
    this.loanDeposit.amount = (Number(this.loanDeposit.amount) * 100) + '';

    this.customerLoanTimelineService.insertMemberLoanDeposit(this.loanDeposit).subscribe((data: any) => {
        this.getInfoLoan();
        this.notifi.success('Deposit inserted');
        $('#new_LoanDeposit').modal('hide');
      }, (err) => {
        this.loanDeposit.amount = (Number(this.loanDeposit.amount) / 100) + '';
        this.notifi.error('While inserting Deposit');
      }
    );
  }
  /////////////////////////////////////////////////////////////// datatable related code begin
  initDataTable() {
    if (!this.customerLoanTimelineDatatable) {
      const curretnClass = this;
      this.customerLoanTimelineDatatable = $('#customerLoanTimelineDatatable').DataTable({
        scrollX: false,
        scrollCollapse: true,
        scrollY:        '200px',
        paging: false,
        pageLength: this.customerLoanTimelineDatatableLength,
        responsive: false,
        sDom: 'Btr',
        searching: true,
        ordering: true,
        retrieve: true,
        fixedColumns: {
          heightMatch: 'none'
        },
        buttons: [
          {
            extend: 'print',
            text: 'Print current page',
            exportOptions: {
              modifier: {
                page: 'current'
              }
            },
            customize(win) {
              $(win.document.body).find('h1').css('text-align', 'center');
              $(win.document.body).find('h1').text(curretnClass.financeService.getLoanCode(curretnClass.loan.id) + ' Loan Timeline');
            }
          },
          'copy', 'csv', 'excel', 'pdf'
        ],
        fnDrawCallback: (osSettings) => {
          this.resetTableListners();
        },
        columnDefs: [
          {
            searchable: false,
            sortable: true,
            targets: [0, 5]
          },
          {
            className: 'text-right',
            targets: [3, 4]
          },
          {
            className: 'text-center',
            targets: [0, 1, 5]
          }],
        order: [[0, 'asc']],
      });
      this.searchData();
    }
  }

  resetTableListners() {
    // store current class reference in _currClassRef variable for using in jquery click event handler
    const currClassRef = this;

    // unbind previous event on tbody so that multiple events are not binded to the table whenever this function runs again
    $('#customerLoanTimelineDatatable tbody td').unbind();

    // defined jquery click event
    $('#customerLoanTimelineDatatable tbody td').on('click', 'button', function() {
      // the "this" in this function is "this" of jquery object not of component because we did not use an arrow function

      // get row for data
      const tr = $(this).closest('tr');
      const row = currClassRef.customerLoanTimelineDatatable.row(tr);
      // this of jquery object
      if ($(this).hasClass('clickDeleteLoanDeposit')) {
        currClassRef.clickDeleteLoanDeposit(row.data()[0]);
      }
    });
  }

  searchData() {
    this.customerLoanTimelineDatatable.search(this.customerLoanTimelineDatatableSearch).draw();
  }

  setDatatableLength() {
    this.customerLoanTimelineDatatable.page.len(this.customerLoanTimelineDatatableLength).draw();
  }

  drawTable() {
    this.initDataTable();

    this.customerLoanTimelineDatatable.clear();

    console.log(this.deposits);
    for (const deposit of this.deposits) {
      let action = '';

      if (deposit.trx_type === 'DEPOSIT') {
        action =
          '<button class="btn btn-mini btn-danger clickDeleteLoanDeposit"> <i class="icofont icofont-ui-delete" aria-hidden="true"></i></button>';
      }

      this.customerLoanTimelineDatatable.row.add([deposit.index + 1, deposit.req_date, deposit.description,
        this.financeService.cents2rupees(deposit.credit),
        this.financeService.cents2rupees(deposit.debit), action]);

    }
    this.customerLoanTimelineDatatable.draw();
  }

  /////////////////////////////////////////////////////////////// datatable related code end
}
