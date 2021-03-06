import {AfterViewInit, Component, OnInit} from '@angular/core';
import {NotificationsService} from '../../../utils/notifications';
import Swal from 'sweetalert2';
import {SavingsService} from './savings.service';
import {FinanceService} from '../utils/finance.service';
import {LeftNavBarService} from '../../left-nav-bar/left-nav-bar.service';

declare var $: any;
declare var jQuery: any;

@Component({
  selector: 'app-savings',
  templateUrl: './savings.component.html',
  styleUrls: ['./savings.component.scss']
})
export class SavingsComponent implements OnInit, AfterViewInit {

  status = {
    0: 'Deleted',
    1: 'Valid',
    4: 'Cancelled'
  };

  savingsDataTableLength = 5;
  savingsDataTableSearch = '';
  savingsDataTable: any;

  totalCurrentDeposit = '0.00';
  totalAllDeposit = '0.00';

  totalCurrentWithdrawal = '0.00';
  totalAllWithdrawal = '0.00';


  diffCurrent = '0.00';
  diffAll = '0.00';

  actionMode = '';

  savings: any[] = [];

  saving = {
    id: -1,
    member_id: '',
    amount: '0.0',
    status: '1',
    note: '',
    req_date: '',
    user_set_req_date: null,
    req_user: '-1',
    trx_type: '',
  };

  members: any[] = [];

  connected = true;

  constructor(private savingsService: SavingsService, private notifi: NotificationsService,
              public financeService: FinanceService, private leftNavBarService: LeftNavBarService) {
  }


  ngOnInit() {
    this.clearSaving();
  }

  ngAfterViewInit(): void {
    this.initDataTable();
    this.getAllSavings();
    this.getActiveMembers();
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
    this.connected = true;
    this.saving.req_date = this.saving.user_set_req_date.year + '-' + this.saving.user_set_req_date.month + '-'
      + this.saving.user_set_req_date.day;
    this.saving.amount = (Number(this.saving.amount) * 100) + '';

    this.savingsService.insertMemberSaving(this.saving).subscribe((data: any) => {
        this.getAllSavings();
        this.notifi.success('Deposit inserted');
        $('#new_Saving').modal('hide');
        this.connected = false;
      }, (err) => {
      this.saving.amount = (Number(this.saving.amount) / 100) + '';
      this.notifi.error('While inserting Deposit');
      this.connected = false;
      }
    );
  }

  clickRegisterWithdrawal() {
    this.connected = true;
    this.saving.req_date = this.saving.user_set_req_date.year + '-' + this.saving.user_set_req_date.month + '-'
      + this.saving.user_set_req_date.day;
    this.saving.amount = (Number(this.saving.amount) * 100) + '';

    this.savingsService.insertMemberWithdraw(this.saving).subscribe((data: any) => {
        this.getAllSavings();
        this.notifi.success('Withdrawal inserted');
        $('#new_Saving').modal('hide');
        this.connected = false;
      }, (err) => {
        this.saving.amount = (Number(this.saving.amount) / 100) + '';
        this.notifi.error('While inserting Withdrawal');
        this.connected = false;
      }
    );
  }

  getSum(arr, index, display) {
    let tot = 0;
    for (const x of display) {
      tot += Number(arr[x][index].split(',').join('')) * 100;
    }
    return this.financeService.cents2rupees(tot);
  }

  clickEditSaving(i) {
    this.actionMode = 'edit';
    this.clearSaving();

    this.saving.id = this.savings[i].id;
    this.saving.member_id = this.savings[i].member_id;
    this.saving.amount = this.financeService.cents2rupees(Number(this.savings[i].amount));
    this.saving.status = this.savings[i].status;
    this.saving.note = this.savings[i].note;
    this.saving.req_date = this.savings[i].req_date;
    this.saving.user_set_req_date.day = Number(this.savings[i].req_date.split('-')[2]);
    this.saving.user_set_req_date.month = Number(this.savings[i].req_date.split('-')[1]);
    this.saving.user_set_req_date.year = Number(this.savings[i].req_date.split('-')[0]);
    this.saving.req_user = this.savings[i].req_user;
    this.saving.trx_type = this.savings[i].trx_type;
    $('#new_Saving').modal({backdrop: 'static', keyboard: false});
  }

  clickUpdateSaving() {
    this.connected = true;
    this.saving.req_date = this.saving.user_set_req_date.year + '-' + this.saving.user_set_req_date.month + '-'
      + this.saving.user_set_req_date.day;
    this.saving.amount = (Number(this.saving.amount) * 100) + '';

    this.savingsService.updateMemberSaving(this.saving).subscribe((data: any) => {
        this.getAllSavings();
        this.notifi.success('Deposit updated');
        $('#new_Saving').modal('hide');
        this.connected = false;
      }, (err) => {
        this.saving.amount = (Number(this.saving.amount) / 100) + '';
        this.notifi.error('While updating Deposit');
        this.connected = false;
      }
    );
  }

  clickUpdateWithdrawal() {
    this.connected = true;
    this.saving.req_date = this.saving.user_set_req_date.year + '-' + this.saving.user_set_req_date.month + '-'
      + this.saving.user_set_req_date.day;
    this.saving.amount = (Number(this.saving.amount) * 100) + '';

    this.savingsService.updateMemberWithdraw(this.saving).subscribe((data: any) => {
        this.getAllSavings();
        this.notifi.success('Withdrawal updated');
        $('#new_Saving').modal('hide');
        this.connected = false;
      }, (err) => {
        this.saving.amount = (Number(this.saving.amount) / 100) + '';
        this.notifi.error('While updating Withdrawal');
        this.connected = false;
      }
    );
  }

  clickDeleteSaving(i) {
    this.actionMode = 'delete';
    this.clearSaving();
    const currentClass = this;
    Swal.fire({
      title: 'Are you sure?',
      text: 'Cancel Saving :' + this.financeService.getSavingCode(this.savings[i].id),
      type: 'warning',
      showCancelButton: true,
      confirmButtonClass: 'btn-danger',
      confirmButtonText: 'Yes, delete!'
    }).then(
      (willDelete) => {
        if (willDelete.value) {
          this.connected = true;
          currentClass.saving.id = currentClass.savings[i].id;
          currentClass.savingsService.cancelMemberSaving(this.saving).subscribe((data: any) => {
              currentClass.getAllSavings();
              currentClass.notifi.success('Saving Cancelled');
              this.connected = false;
            }, (err) => {
              currentClass.notifi.error('While Cancelling Saving');
              this.connected = false;
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
      text: 'Cancel Withdrawal :' + this.financeService.getWithdrawCode(this.savings[i].id),
      type: 'warning',
      showCancelButton: true,
      confirmButtonClass: 'btn-danger',
      confirmButtonText: 'Yes, delete!'
    }).then(
      (willDelete) => {
        if (willDelete.value) {
          this.connected = true;
          currentClass.saving.id = currentClass.savings[i].id;
          currentClass.savingsService.cancelMemberWithdraw(this.saving).subscribe((data: any) => {
              currentClass.getAllSavings();
              currentClass.notifi.success('Withdrawal Cancelled');
              this.connected = false;
            }, (err) => {
              currentClass.notifi.error('While Cancelling Withdrawal');
              this.connected = false;
            }
          );
        }
      });
  }

  clearSaving() {
    const today = new Date();
    // const dd = today.getDate();
    // const mm = today.getMonth() + 1;
    // const yyyy = today.getFullYear();

    this.saving.id = -1;
    this.saving.member_id = '';
    this.saving.amount = '0.0';
    this.saving.status = '1';
    this.saving.note = '-';
    this.saving.req_date = '';
    this.saving.req_user = '-1';
    this.saving.trx_type = '';

    this.saving.user_set_req_date = today;
  }

  getAllSavings() {
    this.connected = true;
    this.savings = [];
    this.savingsService.getAllMemberSavings().subscribe((data: any) => {
        this.savings = data;
        this.financeService.addIndex(this.savings);
        this.drawTable();
        this.connected = false;
      }, (err) => {
        this.notifi.error('While fetching Saving details');
        this.savingsDataTable.clear();
        this.savingsDataTable.draw();
        this.connected = false;
      }
    );
  }

  getActiveMembers() {
    this.connected = true;
    this.members = [];
    this.savingsService.getAllCustomers().subscribe((data: any) => {
        this.members = data;
        this.financeService.addIndex(this.members);
        this.connected = false;
      }, (err) => {
        this.notifi.error('While fetching Member details');
        this.connected = false;
      }
    );
  }

  refreshSavings() {
    this.savingsDataTableSearch = '';
    this.getAllSavings();
    this.getActiveMembers();
    this.searchData();
  }

  gotoCustomer(i) {
    this.leftNavBarService.navigate('/app/customer',
      { queryParams: { code: this.financeService.getCustomerCode(this.savings[i].member_id) } });
  }
  /////////////////////////////////////////////////////////////// datatable related code begin
  initDataTable() {
    if (!this.savingsDataTable) {
      this.savingsDataTable = $('#savingsDataTable').DataTable({
        scrollX: false,
        scrollCollapse: true,
        paging: true,
        pageLength: this.savingsDataTableLength,
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
              $(win.document.body).find('h1').text('Savings Ledger');
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
            targets: [0, 8]
          },
          {
            visible: false,
            targets: [0]
          },
          {
            className: 'text-right',
            targets: [4, 8, 9]
          }],
        order: [[0, 'asc']],
        footerCallback: (row, data, start, end, display) => {
          this.totalCurrentDeposit = this.getSum(data, 8, display.slice(start, end));
          this.totalCurrentWithdrawal = this.getSum(data, 9, display.slice(start, end));
          this.totalAllDeposit = this.getSum(data, 8, display);
          this.totalAllWithdrawal = this.getSum(data, 9, display);
          this.diffCurrent = this.financeService.cents2rupees(Number(this.totalCurrentDeposit) * 100 -
            Number(this.totalCurrentWithdrawal) * 100);
          this.diffAll = this.financeService.cents2rupees(Number(this.totalAllDeposit) * 100 -
            Number(this.totalAllWithdrawal) * 100);
        }
      });
    }
  }

  resetTableListners() {
    // store current class reference in _currClassRef variable for using in jquery click event handler
    const currClassRef = this;

    // unbind previous event on tbody so that multiple events are not binded to the table whenever this function runs again
    $('#savingsDataTable tbody td').unbind();

    // defined jquery click event
    $('#savingsDataTable tbody td').on('click', 'button', function() {
      // the "this" in this function is "this" of jquery object not of component because we did not use an arrow function

      // get row for data
      const tr = $(this).closest('tr');
      const row = currClassRef.savingsDataTable.row(tr);
      // this of jquery object
      if ($(this).hasClass('editSaving')) {
        currClassRef.clickEditSaving(row.data()[0]);
      } else if ($(this).hasClass('deleteSaving')) {
        currClassRef.clickDeleteSaving(row.data()[0]);
      } else if ($(this).hasClass('deleteWithdrawal')) {
        currClassRef.clickDeleteWithdrawal(row.data()[0]);
      } else if ($(this).hasClass('gotoCustomer')) {
        currClassRef.gotoCustomer(row.data()[0]);
      }

    });
  }

  searchData() {
    this.savingsDataTable.search(this.savingsDataTableSearch).draw();
  }

  setDatatableLength() {
    this.savingsDataTable.page.len(this.savingsDataTableLength).draw();
  }

  drawTable() {
    this.initDataTable();
    // this.customerDataTable.rows().every(function(rowIdx, tableLoop, rowLoop) {
    //   this.invalidate();
    // });
    this.savingsDataTable.clear();
    // this.datatable.clear();
    // this.datatable.rows.add(this.doctors);
    // this.datatable.draw();

// Draw once all updates are done
//     this.dataTable.rows().clear().draw();
    for (const saving of this.savings) {
      let action =
        '<button class="btn btn-mini btn-warning editSaving" > <i class="icofont icofont-edit-alt" aria-hidden="true"></i></button> ' +
        '<button class="btn btn-mini btn-danger deleteSaving"> <i class="icofont icofont-ui-delete" aria-hidden="true"></i></button>';

      let withdrawal = this.financeService.toLocale(this.financeService.cents2rupees(saving.amount));
      let deposit = this.financeService.toLocale(this.financeService.cents2rupees(saving.amount));
      let code = this.financeService.getSavingCode(saving.id);
      let status = 'Deposit';
      if (saving.trx_type === 'WITHDRAWAL') {
        code = this.financeService.getWithdrawCode(saving.id);
        deposit = '0.00';
        status = 'Withdrawal';
        action =
          '<button class="btn btn-mini btn-warning editSaving" > <i class="icofont icofont-edit-alt" aria-hidden="true"></i></button> ' +
          '<button class="btn btn-mini btn-danger deleteWithdrawal"> <i class="icofont icofont-ui-delete" aria-hidden="true"></i></button>';
      } else {
        withdrawal = '0.00';
      }

      if (saving.status === '4') {
        status = 'Cancelled ' + status;
        withdrawal = '0.00';
        deposit = '0.00';
        action = '';
      }

      const memberID =
        `<button class="astext gotoCustomer">` + saving.member_name + `</button>`;


      this.savingsDataTable.row.add([saving.index, code, memberID, saving.req_date,
        this.financeService.toLocale(this.financeService.cents2rupees(saving.amount)), saving.note, status,
        saving.updated_by, deposit, withdrawal, action]);

    }
    this.savingsDataTable.draw();
  }

  /////////////////////////////////////////////////////////////// datatable related code end
}
