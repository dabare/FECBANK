import {AfterViewInit, Component, OnInit} from '@angular/core';
import {NotificationsService} from '../../../utils/notifications';
import Swal from 'sweetalert2';
import {LoansService} from './loans.service';
import {FinanceService} from '../utils/finance.service';
import {ActivatedRoute, Router} from '@angular/router';
import {LeftNavBarService} from '../../left-nav-bar/left-nav-bar.service';
import {environment} from '../../../../environments/environment.prod';

declare var $: any;
declare var jQuery: any;

@Component({
  selector: 'app-loans',
  templateUrl: './loans.component.html',
  styleUrls: ['./loans.component.scss']
})
export class LoansComponent implements OnInit, AfterViewInit {

  loanStatus = {
    0: 'Cancelled',
    1: 'Active',
    2: 'Completed'
  };

  loansDataTableLength = 5;
  loansDataTableSearch = '';
  loansDataTable: any;

  actionMode = '';

  loans: any[] = [];

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
    total: '',
    member_name: '',
    nextDueDate: '',
    nextDueAmount: '',
  };

  customers: any[] = [];

  connected = true;
  constructor(private route: ActivatedRoute, private loansService: LoansService, private notifi: NotificationsService,
              public financeService: FinanceService, private leftNavBarService: LeftNavBarService) {
  }


  ngOnInit() {
    this.route.queryParams.subscribe(params => {
      if (params && params.code) {
        this.loansDataTableSearch = params.code;
      }
    });
    this.clearLoan();
  }

  ngAfterViewInit(): void {
    this.initDataTable();
    this.getAllLoans();
    this.getAllCustomers();
  }

  clickNewLoan() {
    this.actionMode = 'new';
    this.clearLoan();
    $('#new_Loan').modal({backdrop: 'static', keyboard: false});
  }

  clickRegisterLoan() {
    this.connected  = true;
    this.loan.req_date = this.loan.user_set_req_date.year + '-' + this.loan.user_set_req_date.month + '-' + this.loan.user_set_req_date.day;
    this.loan.amount = (Number(this.loan.amount) * 100) + '';
    this.loan.charges = (Number(this.loan.charges) * 100) + '';
    this.loan.late_payment_charge = (Number(this.loan.late_payment_charge) * 100) + '';
    this.loan.reject_cheque_penalty = (Number(this.loan.reject_cheque_penalty) * 100) + '';
    this.loan.rental = this.financeService.getLoanInstallment(Number(this.loan.amount),
      Number(this.loan.rate), Number(this.loan.duration_months)) + '';
    this.loansService.insertMemberLoan(this.loan).subscribe((data: any) => {
        this.getAllLoans();
        this.notifi.success('Loan inserted');
        $('#new_Loan').modal('hide');
        this.connected = false;
      }, (err) => {
        this.loan.amount = (Number(this.loan.amount) / 100) + '';
        this.loan.charges = (Number(this.loan.charges) / 100) + '';
        this.loan.late_payment_charge = (Number(this.loan.late_payment_charge) / 100) + '';
        this.loan.reject_cheque_penalty = (Number(this.loan.reject_cheque_penalty) / 100) + '';
        this.notifi.error('While inserting Loan');
        this.connected = false;
      }
    );
  }

  addIndex(array: any[]) {
    for (let index = 0; index < array.length; index++) {
      array[index].index = index;
    }
  }

  loadLoan(i) {
    this.loan.code = this.loans[i].code;
    this.loan.member_id = this.loans[i].member_id;
    this.loan.member_loan_plan_id = this.loans[i].member_loan_plan_id;
    this.loan.rate = this.loans[i].rate;
    this.loan.amount = this.financeService.cents2rupees(Number(this.loans[i].amount));
    this.loan.charges = this.financeService.cents2rupees(Number(this.loans[i].charges));
    this.loan.duration_months = this.loans[i].duration_months;
    this.loan.grace_period_days = this.loans[i].grace_period_days;
    this.loan.late_payment_charge = this.financeService.cents2rupees(Number(this.loans[i].late_payment_charge));
    this.loan.reject_cheque_penalty = this.financeService.cents2rupees(Number(this.loans[i].reject_cheque_penalty));
    this.loan.status = this.loans[i].status;
    this.loan.note = this.loans[i].note;
    this.loan.req_date = this.loans[i].req_date;
    this.loan.user_set_req_date.day = Number(this.loans[i].req_date.split('-')[2]);
    this.loan.user_set_req_date.month = Number(this.loans[i].req_date.split('-')[1]);
    this.loan.user_set_req_date.year = Number(this.loans[i].req_date.split('-')[0]);
    this.loan.req_user = this.loans[i].req_user;
    this.loan.updated_by = this.loans[i].updated_by;
    this.loan.rental = this.financeService.cents2rupees(this.loans[i].rental);
    const total = Number(this.loans[i].rental) * Number(this.loan.duration_months);
    const interest = total - Number(this.loans[i].amount);
    this.loan.interest = this.financeService.cents2rupees(interest);
    this.loan.total = this.financeService.cents2rupees(total);
    this.loan.member_name = this.loans[i].member_name;
    this.loan.id = this.loans[i].id;
    this.loan.nextDueAmount = this.loans[i].nextDueAmount;
    this.loan.nextDueDate = this.loans[i].nextDueDate;
  }

  clickEditLoan(i) {
    this.actionMode = 'edit';
    this.clearLoan();
    this.loadLoan(i);
    $('#new_Loan').modal({backdrop: 'static', keyboard: false});
  }

  clickUpdateLoan() {
    this.connected = true;
    this.loan.req_date = this.loan.user_set_req_date.year + '-' + this.loan.user_set_req_date.month + '-' + this.loan.user_set_req_date.day;
    this.loan.amount = (Number(this.loan.amount) * 100) + '';
    this.loan.charges = (Number(this.loan.charges) * 100) + '';
    this.loan.late_payment_charge = (Number(this.loan.late_payment_charge) * 100) + '';
    this.loan.reject_cheque_penalty = (Number(this.loan.reject_cheque_penalty) * 100) + '';
    this.loan.rental = this.financeService.getLoanInstallment(Number(this.loan.amount),
      Number(this.loan.rate), Number(this.loan.duration_months)) + '';
    this.loansService.updateMemberLoan(this.loan).subscribe((data: any) => {
        this.getAllLoans();
        this.notifi.success('Loan Updated');
        $('#new_Loan').modal('hide');
        this.connected = false;
      }, (err) => {
      this.loan.amount = (Number(this.loan.amount) / 100) + '';
      this.loan.charges = (Number(this.loan.charges) / 100) + '';
      this.loan.late_payment_charge = (Number(this.loan.late_payment_charge) / 100) + '';
      this.loan.reject_cheque_penalty = (Number(this.loan.reject_cheque_penalty) / 100) + '';
      this.notifi.error('While Updating Loan');
      this.connected = false;
      }
    );
  }

  clickDeleteLoan(i) {
    this.actionMode = 'delete';
    this.clearLoan();
    const currentClass = this;
    Swal.fire({
      title: 'Are you sure?',
      text: 'Delete ' + this.financeService.getLoanCode(this.loans[i].id),
      type: 'warning',
      showCancelButton: true,
      confirmButtonClass: 'btn-danger',
      confirmButtonText: 'Yes, delete!'
    }).then(
      (willDelete) => {
        if (willDelete.value) {
          this.connected = true;
          currentClass.loan.id = currentClass.loans[i].id;
          currentClass.loansService.deleteMemberLoan(this.loan).subscribe((data: any) => {
              currentClass.getAllLoans();
              currentClass.notifi.success('Loan Deleted');
              this.connected = false;
            }, (err) => {
              currentClass.notifi.error('While Deleting Loan');
              this.connected = false;
            }
          );
        }
      });
  }

  clickInfoLoan(i) {
    this.actionMode = 'info';
    this.clearLoan();
    this.loadLoan(i);
  }

  gotoCustomer(i) {
    this.leftNavBarService.navigate('/app/customer',
      { queryParams: { code: this.financeService.getCustomerCode(this.loans[i].member_id) } });
  }

  gotoLoanDeposits(i) {
    this.leftNavBarService.navigate('/app/loan-deposits',
      { queryParams: { code: this.financeService.getLoanCode(this.loans[i].id) } });
  }

  clearLoan() {
    const today = new Date();
    const dd = today.getDate();
    const mm = today.getMonth() + 1;
    const yyyy = today.getFullYear();

    this.loan.id = -1;
    this.loan.code = '-';
    this.loan.member_id = '';
    this.loan.member_loan_plan_id = '-1';
    this.loan.rate = '1';
    this.loan.amount = '0.0';
    this.loan.charges = '0.0';
    this.loan.duration_months = 0;
    this.loan.grace_period_days = 0;
    this.loan.late_payment_charge = '0.0';
    this.loan.reject_cheque_penalty = '0.0';
    this.loan.status = '1';
    this.loan.note = '-';
    this.loan.req_date = '';
    this.loan.req_user = '-1';
    this.loan.updated_by = '';
    this.loan.rental = '0.00';
    this.loan.interest = '0.00';
    this.loan.total = '0.00';
    this.loan.nextDueDate = '';
    this.loan.nextDueAmount = '';

    this.loan.user_set_req_date = today;
  }

  getLoanDetails() {
    for (let i = 0; i < this.loans.length; i++) {
      if (this.loans[i].status === '1') {
        this.loansService.getDepositsOfLoan(this.loans[i]).subscribe((data: any) => {
            data  = this.financeService.processLoanHistory(data, this.loans[i].req_date,
              Number(this.loans[i].amount),
              Number(this.loans[i].duration_months),
              Number(this.loans[i].rate),
              Number(this.loans[i].rental),
              Number(this.loans[i].total),
              0);
            this.loans[i].nextDueDate = data[data.length - 1].nextDueDate;
            this.loans[i].nextDueAmount = data[data.length - 1].nextDueAmount;
            this.drawTable();
          }, (err) => {
            this.notifi.error('While fetching Loan details');
          }
        );
      }

    }
  }

  getAllLoans() {
    this.connected = true;
    this.loans = [];
    this.loansService.getAllMemberLoans().subscribe((data: any) => {
        this.loans = data;
        this.addIndex(this.loans);
        this.getLoanDetails();
        this.drawTable();
        this.connected = false;
      }, (err) => {
        this.notifi.error('While fetching Loan details');
        this.loansDataTable.clear();
        this.loansDataTable.draw();
        this.connected = false;
      }
    );
  }

  getAllCustomers() {
    this.connected = true;
    this.customers = [];
    this.loansService.getAllCustomers().subscribe((data: any) => {
        this.customers = data;
        this.addIndex(this.customers);
        this.connected = false;
      }, (err) => {
        this.notifi.error('While fetching Member details');
        this.connected = false;
      }
    );
  }

  refreshLoans() {
    this.loansDataTableSearch = '';
    this.actionMode = '';
    this.getAllLoans();
    this.getAllCustomers();
    this.searchData();
  }

  /////////////////////////////////////////////////////////////// datatable related code begin
  initDataTable() {
    if (!this.loansDataTable) {
      this.loansDataTable = $('#loansDataTable').DataTable({
        scrollX: false,
        scrollCollapse: true,
        paging: true,
        pageLength: this.loansDataTableLength,
        responsive: false,
        sDom: 'Btipr',
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
              // $(win.document.body).find('table').addClass('display').css('font-size', '9px');
              // $(win.document.body).find('tr:nth-child(odd) td').each(function(index){
              //   $(this).css('background-color','#D0D0D0');
              // });
              $(win.document.body).find('h1').css('text-align', 'center');
              $(win.document.body).find('h1').text('Loans');
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
            sortable: false,
            targets: [0, 11]
          },
          {
            visible: false,
            targets: [0]
          },
          {
            className: 'text-right',
            targets: [5, 7]
          },
          {
            className: 'text-center',
            targets: [1, 2, 3, 4, 6, 9, 11]
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
    $('#loansDataTable tbody td').unbind();

    // defined jquery click event
    $('#loansDataTable tbody td').on('click', 'button', function() {
      // the "this" in this function is "this" of jquery object not of component because we did not use an arrow function

      // get row for data
      const tr = $(this).closest('tr');
      const row = currClassRef.loansDataTable.row(tr);
      // this of jquery object
      if ($(this).hasClass('editLoan')) {
        // use function of current class using reference
        // _currClassRef.showValue(row.data().FirstName);
        currClassRef.clickEditLoan(row.data()[0]);
      } else if ($(this).hasClass('deleteLoan')) {
        currClassRef.clickDeleteLoan(row.data()[0]);
      } else if ($(this).hasClass('infoLoan')) {
        currClassRef.clickInfoLoan(row.data()[0]);
      } else if ($(this).hasClass('gotoCustomer')) {
        currClassRef.gotoCustomer(row.data()[0]);
      } else if ($(this).hasClass('gotoLoanDeposits')) {
        currClassRef.gotoLoanDeposits(row.data()[0]);
      }

    });
  }

  searchData() {
    this.loansDataTable.search(this.loansDataTableSearch).draw();
  }

  setDatatableLength() {
    this.loansDataTable.page.len(this.loansDataTableLength).draw();
  }

  drawTable() {
    this.initDataTable();
    // this.customerDataTable.rows().every(function(rowIdx, tableLoop, rowLoop) {
    //   this.invalidate();
    // });
    this.loansDataTable.clear();
    // this.datatable.clear();
    // this.datatable.rows.add(this.doctors);
    // this.datatable.draw();

// Draw once all updates are done
//     this.dataTable.rows().clear().draw();
    for (const loan of this.loans) {
      let action =
        '<button class="btn btn-mini btn-info infoLoan" > <i class="icofont icofont-info" aria-hidden="true"></i></button> ' +
        '<button class="btn btn-mini btn-warning editLoan" > <i class="icofont icofont-edit-alt" aria-hidden="true"></i></button> ' +
        '<button class="btn btn-mini btn-danger deleteLoan"> <i class="icofont icofont-ui-delete" aria-hidden="true"></i></button>';

      if (loan.status !== '1') {
        action =
          '<button class="btn btn-mini btn-info infoLoan" > <i class="icofont icofont-info" aria-hidden="true"></i></button> ' +
          '<button class="btn btn-mini btn-warning" disabled> <i class="icofont icofont-edit-alt" aria-hidden="true"></i></button> ' +
          '<button class="btn btn-mini btn-danger deleteLoan"> <i class="icofont icofont-ui-delete" aria-hidden="true"></i></button>';
      }

      const memberID =
        `<button class="astext gotoCustomer">` + loan.member_name + `</button>`;
      const loanID =
        `<button class="astext gotoLoanDeposits">` + this.financeService.getLoanCode(loan.id) + `</button>`;


      this.loansDataTable.row.add([loan.index, loanID,
        memberID,
        loan.req_date, loan.rate + '%', this.financeService.toLocale(this.financeService.cents2rupees(loan.amount)),
        loan.duration_months, this.financeService.toLocale(this.financeService.cents2rupees(loan.rental)), loan.note,
        loan.nextDueDate ? loan.nextDueDate : '-',
          this.loanStatus[loan.status], action]);

    }
    this.loansDataTable.draw();
  }

  /////////////////////////////////////////////////////////////// datatable related code end
}
