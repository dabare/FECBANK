import {AfterViewInit, Component, Input, OnChanges, OnInit} from '@angular/core';
import {FinanceService} from '../../utils/finance.service';
import {CustomerSavingsTimelineService} from './customer-savings-timeline.service';
import {NotificationsService} from '../../../../utils/notifications';
import Swal from 'sweetalert2';

declare var $: any;
declare var jQuery: any;

@Component({
  selector: 'app-customer-savings-timeline',
  templateUrl: './customer-savings-timeline.component.html',
  styleUrls: ['./customer-savings-timeline.component.scss']
})
export class CustomerSavingsTimelineComponent implements OnChanges {

  customer = {
    id: -1,
    code: '-',
    name: '-',
    nic: '-',
    dob: '-',
    tel: '-',
    address: '-',
    email: '-',
    representative: '-1',
    bondsman: '-',
    bondsman_nic: '-',
    status: 0,
    req_date: '-',
    req_user: '-1'
  };

  savingHistory: any[] = [];

  saving = {
    id: -1,
    member_id: this.customer.id,
    amount: '0.0',
    status: '1',
    note: '',
    req_date: '',
    user_set_req_date: null,
    req_user: '-1',
    trx_type: '',
  };

  actionMode = '';

  customerSavingsTimelineDatatableLength = -1;
  customerSavingsTimelineDatatableSearch = '';
  customerSavingsTimelineDatatable: any;

  @Input()
  customerId: number;
  @Input()
  customerName: string;

  constructor(public financeService: FinanceService,
              private customerSavingsTimelineService: CustomerSavingsTimelineService,
              private notifi: NotificationsService) {
  }


  ngOnChanges() {
    this.customer.id = this.customerId;
    this.customer.name = this.customerName;
    this.getInfoCustomer();
  }

  getInfoCustomer() {
    this.savingHistory = [];
    this.customerSavingsTimelineDatatableSearch = '';
    this.customerSavingsTimelineService.getCustomerSavingHistory(this.customer).subscribe((data: any) => {
        this.savingHistory = this.financeService.processSavingHistory(data);
        this.financeService.addIndex(this.savingHistory);
        this.drawTable();
      }, (err) => {
        this.notifi.error('While fetching Member History');
      }
    );
  }

  clearSaving() {
    const today = new Date();

    this.saving.id = -1;
    this.saving.member_id = this.customer.id;
    this.saving.amount = '0.0';
    this.saving.status = '1';
    this.saving.note = '-';
    this.saving.req_date = '';
    this.saving.req_user = '-1';
    this.saving.trx_type = '';

    this.saving.user_set_req_date = today;
  }


  clickNewSaving() {
    this.actionMode = 'new';
    this.clearSaving();
    this.saving.trx_type = 'DEPOSIT';
    $('#new_Saving').modal({backdrop: 'static', keyboard: false});
  }

  clickNewWithdrawal() {
    this.actionMode = 'new';
    this.clearSaving();
    this.saving.trx_type = 'WITHDRAWAL';
    $('#new_Saving').modal({backdrop: 'static', keyboard: false});
  }

  clickRegisterSaving() {
    this.saving.req_date = this.saving.user_set_req_date.year + '-' + this.saving.user_set_req_date.month + '-'
      + this.saving.user_set_req_date.day;
    this.saving.amount = (Number(this.saving.amount) * 100) + '';

    this.customerSavingsTimelineService.insertMemberSaving(this.saving).subscribe((data: any) => {
        this.getInfoCustomer();
        this.notifi.success('Deposit inserted');
        $('#new_Saving').modal('hide');
      }, (err) => {
        this.saving.amount = (Number(this.saving.amount) / 100) + '';
        this.notifi.error('While inserting Deposit');
      }
    );
  }

  clickRegisterWithdrawal() {
    this.saving.req_date = this.saving.user_set_req_date.year + '-' + this.saving.user_set_req_date.month + '-'
      + this.saving.user_set_req_date.day;
    this.saving.amount = (Number(this.saving.amount) * 100) + '';

    this.customerSavingsTimelineService.insertMemberWithdraw(this.saving).subscribe((data: any) => {
        this.getInfoCustomer();
        this.notifi.success('Withdrawal inserted');
        $('#new_Saving').modal('hide');
      }, (err) => {
        this.saving.amount = (Number(this.saving.amount) / 100) + '';
        this.notifi.error('While inserting Withdrawal');
      }
    );
  }

  clickUpdateSaving() {
    this.saving.req_date = this.saving.user_set_req_date.year + '-' + this.saving.user_set_req_date.month + '-'
      + this.saving.user_set_req_date.day;
    this.saving.amount = (Number(this.saving.amount) * 100) + '';

    this.customerSavingsTimelineService.updateMemberSaving(this.saving).subscribe((data: any) => {
        this.getInfoCustomer();
        this.notifi.success('Deposit updated');
        $('#new_Saving').modal('hide');
      }, (err) => {
        this.saving.amount = (Number(this.saving.amount) / 100) + '';
        this.notifi.error('While updating Deposit');
      }
    );
  }

  clickUpdateWithdrawal() {
    this.saving.req_date = this.saving.user_set_req_date.year + '-' + this.saving.user_set_req_date.month + '-'
      + this.saving.user_set_req_date.day;
    this.saving.amount = (Number(this.saving.amount) * 100) + '';

    this.customerSavingsTimelineService.updateMemberWithdraw(this.saving).subscribe((data: any) => {
        this.getInfoCustomer();
        this.notifi.success('Withdrawal updated');
        $('#new_Saving').modal('hide');
      }, (err) => {
        this.saving.amount = (Number(this.saving.amount) / 100) + '';
        this.notifi.error('While updating Withdrawal');
      }
    );
  }

  clickDeleteSaving(i) {
    this.actionMode = 'delete';
    this.clearSaving();
    const currentClass = this;
    Swal.fire({
      title: 'Are you sure?',
      text: 'Cancel Saving :' + this.financeService.getSavingCode(this.savingHistory[i - 1].id),
      type: 'warning',
      showCancelButton: true,
      confirmButtonClass: 'btn-danger',
      confirmButtonText: 'Yes, delete!'
    }).then(
      (willDelete) => {
        if (willDelete.value) {
          currentClass.saving.id = currentClass.savingHistory[i - 1].id;
          currentClass.customerSavingsTimelineService.cancelMemberSaving(this.saving).subscribe((data: any) => {
              currentClass.getInfoCustomer();
              currentClass.notifi.success('Saving Cancelled');
            }, (err) => {
              currentClass.notifi.error('While Cancelling Saving');
            }
          );
        }
      });
  }

  clickDeleteWithdrawal(i) {
    this.actionMode = 'delete';
    this.clearSaving();
    const currentClass = this;
    Swal.fire({
      title: 'Are you sure?',
      text: 'Cancel Withdrawal :' + this.financeService.getWithdrawCode(this.savingHistory[i - 1].id),
      type: 'warning',
      showCancelButton: true,
      confirmButtonClass: 'btn-danger',
      confirmButtonText: 'Yes, delete!'
    }).then(
      (willDelete) => {
        if (willDelete.value) {
          currentClass.saving.id = currentClass.savingHistory[i - 1].id;
          currentClass.customerSavingsTimelineService.cancelMemberWithdraw(this.saving).subscribe((data: any) => {
              currentClass.getInfoCustomer();
              currentClass.notifi.success('Withdrawal Cancelled');
            }, (err) => {
              currentClass.notifi.error('While Cancelling Withdrawal');
            }
          );
        }
      });
  }

  /////////////////////////////////////////////////////////////// datatable related code begin
  initDataTable() {
    if (!this.customerSavingsTimelineDatatable) {
      const curretnClass = this;
      this.customerSavingsTimelineDatatable = $('#customerSavingsTimelineDatatable').DataTable({
        scrollX: false,
        scrollCollapse: true,
        paging: true,
        pageLength: this.customerSavingsTimelineDatatableLength,
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
              $(win.document.body).find('h1').text(curretnClass.financeService.getCustomerCode(curretnClass.customer.id) + ' - ' +
                curretnClass.customer.name
                + ' Savings Timeline');
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
            targets: [9]
          },
          {
            searchable: false,
            sortable: true,
            targets: [0]
          },
          {
            className: 'text-right',
            targets: [3, 6, 7, 8]
          },
          {
            className: 'text-center',
            targets: [0, 1, 4, 5]
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
    $('#customerSavingsTimelineDatatable tbody td').unbind();

    // defined jquery click event
    $('#customerSavingsTimelineDatatable tbody td').on('click', 'button', function() {
      // the "this" in this function is "this" of jquery object not of component because we did not use an arrow function

      // get row for data
      const tr = $(this).closest('tr');
      const row = currClassRef.customerSavingsTimelineDatatable.row(tr);
      // this of jquery object
      if ($(this).hasClass('clickDeleteWithdrawal')) {
        currClassRef.clickDeleteWithdrawal(row.data()[0]);
      } else if ($(this).hasClass('clickDeleteSaving')) {
        currClassRef.clickDeleteSaving(row.data()[0]);
      }
    });
  }

  searchData() {
    this.customerSavingsTimelineDatatable.search(this.customerSavingsTimelineDatatableSearch).draw();
  }

  setDatatableLength() {
    this.customerSavingsTimelineDatatable.page.len(this.customerSavingsTimelineDatatableLength).draw();
  }

  drawTable() {
    this.initDataTable();

    this.customerSavingsTimelineDatatable.clear();

    for (const saving of this.savingHistory) {
      let action = '';

      if (saving.trx_type === 'DEPOSIT') {
        action =
          '<button class="btn btn-mini btn-danger clickDeleteSaving"> <i class="icofont icofont-ui-delete" aria-hidden="true"></i></button>';
      } else if (saving.trx_type === 'WITHDRAWAL') {
        action =
          '<button class="btn btn-mini btn-danger clickDeleteWithdrawal"> <i class="icofont icofont-ui-delete" aria-hidden="true"></i></button>';
      }

      this.customerSavingsTimelineDatatable.row.add([saving.index + 1, saving.req_date, saving.description,
        this.financeService.cents2rupees(saving.amount),
        saving.rate, saving.days_passed, this.financeService.cents2rupees(saving.interest),
        this.financeService.cents2rupees(saving.balance), this.financeService.cents2rupees(saving.total), action]);

    }
    this.customerSavingsTimelineDatatable.draw();
  }

  /////////////////////////////////////////////////////////////// datatable related code end
}
