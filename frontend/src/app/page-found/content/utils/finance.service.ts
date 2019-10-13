import {Injectable} from '@angular/core';

@Injectable({
  providedIn: 'root'
})

export class FinanceService {


  constructor() {
  }

  public addIndex(array: any[]) {
    for (let index = 0; index < array.length; index++) {
      array[index].index = index;
    }
    return array;
  }

  public getCustomerCode(id) {
    while (id.length < 3) {
      id = '0' + id;
    }
    return 'MEM' + id;
  }

  public getDepositCode(id) {
    while (id.length < 5) {
      id = '0' + id;
    }
    return 'INVL' + id;
  }

  public getSavingCode(id) {
    while (id.length < 5) {
      id = '0' + id;
    }
    return 'INVD' + id;
  }

  public getWithdrawCode(id) {
    while (id.length < 5) {
      id = '0' + id;
    }
    return 'INVW' + id;
  }

  public getLoanCode(id) {
    while (id.length < 4) {
      id = '0' + id;
    }
    return 'LOAN' + id;
  }


  public cents2rupees(cents) {
    cents = Math.ceil(cents);
    let sign = '';
    if (cents < 0) {
      sign = '-';
      cents *= -1;
    }
    const rupees = Math.floor(cents / 100);
    cents = cents % 100 + '';
    while (cents.length < 2) {
      cents = '0' + cents;
    }
    return sign + rupees + '.' + cents;
  }

  public toLocale(str) {
    return Number(str.split('.')[0]).toLocaleString('en') + '.' + str.split('.')[1];
  }

  public processSavingHistory(data: any[]) {
    const d = new Date();
    let dd = d.getFullYear() + '-' + (d.getMonth() + 1) ;
    if ( d.getDate() < 10) {
      dd += '-0' + d.getDate();
    } else {
      dd += '-' + d.getDate();
    }
    let firstSaving = 0;
    let currentRateIndex = 0;
    data.push(
      {
        trx_type: 'BALANCE',
        req_date: dd
      }
    );
    for (let i = 0; i < data.length; i++) {

      if (firstSaving === 0 && data[i].trx_type !== 'RATE') {
        firstSaving = i;
      }

      if (data[i].trx_type === 'RATE') {
        data[i].description = 'Rate Change ' + data[i].description;
        data[i].amount = 0;
        currentRateIndex = i;
      } else if (data[i].trx_type === 'DEPOSIT') {
        data[i].description = 'Deposit ' + data[i].description;
        data[i].amount = Number(data[i].value);
      } else if (data[i].trx_type === 'WITHDRAWAL') {
        data[i].description = 'Withdrawal ' + data[i].description;
        data[i].amount = -1 * Number(data[i].value);
      } else if (data[i].trx_type === 'BALANCE') {
        data[i].description = 'Balance Upto Now';
        data[i].amount = 0;
      }

      const newDate = new Date(data[i].req_date.split('-')[0],
        data[i].req_date.split('-')[1], data[i].req_date.split('-')[2]);
      let oldDate = newDate;

      data[i].rate = Number(data[currentRateIndex].value);

      if (i === 0) {
        data[i].interest = 0;
        data[i].balance = 0;
        data[i].total = 0;
        data[i].days_passed = 0;
      } else if (i > 0) {
        oldDate = new Date(data[i - 1].req_date.split('-')[0],
          data[i - 1].req_date.split('-')[1], data[i - 1].req_date.split('-')[2]);
        data[i].days_passed = Math.ceil((newDate.getTime() - oldDate.getTime()) / (1000 * 60 * 60 * 24));
        data[i].interest = (data[i - 1].total * data[i].days_passed
          * data[i - 1].rate) / 36500;
        data[i].balance = data[i - 1].total + data[i].interest;
        data[i].total = data[i].balance + data[i].amount;
      }

    }
    data[firstSaving - 1].interest = 0;
    data[firstSaving - 1].balance = 0;
    data[firstSaving - 1].total = 0;
    data[firstSaving - 1].days_passed = 0;
    return data.slice(firstSaving - 1, data.length);
  }

  public getLoanInstallment(principalAmount, annualRate, numberOfPayments) {
    const a = Math.pow( 1 + annualRate / 1200, numberOfPayments);
    return Math.ceil(principalAmount * annualRate * a / (1200 * (a - 1)));
  }

  public processLoanHistory(data: any[], initDate, amount, durationMonths, rate, rental, total, penalty) {
    return this.addIndex(this.mapLoanPaymentWithDays(data, this.getLoanSettlementDates(initDate, durationMonths, total, rental)));
  }

  private getLoanSettlementDates(initDate, durationMonths, total, rental) {
    const days = [];
    let paymentInitDate = '05'; // pays 5th 15th or 25th
    let paymentInitMonth = Number(initDate.split('-')[1]) - 1;
    let paymentInitYear = Number(initDate.split('-')[0]);
    if (Number(initDate.split('-')[2]) > 5 && Number(initDate.split('-')[2]) <= 15 ) {
      paymentInitDate = '15';
    } else if (Number(initDate.split('-')[2]) > 15 && Number(initDate.split('-')[2]) <= 25 ) {
      paymentInitDate = '25';
    } else if (Number(initDate.split('-')[2]) > 25) {
      paymentInitMonth++;
      paymentInitMonth = paymentInitMonth % 12;
      if (paymentInitMonth === 0) {// if january, means last was december, so new year
        paymentInitYear++;
      }
    }

    days.push({
      id: '-1',
      req_date: paymentInitYear + '-' + (paymentInitMonth < 9 ? '0' : '' ) + (paymentInitMonth + 1) + '-' + paymentInitDate,
      description: 'Agreement',
      credit: 0,
      debit: total,
      trx_type: 'INIT'
    });

    for (let i = 0; i < durationMonths; i++) {
      paymentInitMonth++;
      paymentInitMonth = paymentInitMonth % 12;
      if (paymentInitMonth === 0) {// if january, means last was december, so new year
        paymentInitYear++;
      }
      days.push({
        id: '-1',
        req_date: paymentInitYear + '-' + (paymentInitMonth < 9 ? '0' : '' ) + (paymentInitMonth + 1) + '-' + paymentInitDate,
        description: 'Due amount: Rs. ' + this.toLocale(this.cents2rupees(rental)) + '/=',
        credit: 0,
        debit: 0,
        trx_type: 'DUEDATE'
      });
    }
    return days;
  }

  private mapLoanPaymentWithDays(payments: any[], days: any[]) {
    let credit = Number(days[0].credit);
    let debit = Number(days[0].debit);
    for (let i = 0; i < payments.length; i++) {
      days[i + 1].credit = payments[i].amount;
      days[i + 1].description = 'Payed on ' + payments[i].req_date + ' ' + this.getDepositCode(payments[i].id);
      credit += Number(days[i + 1].credit);
      debit += Number(days[i + 1].debit);
      days[i + 1].id = payments[i].id;
      days[i + 1].trx_type = 'DEPOSIT';
    }
    days.push({
      id: '-1',
      req_date: '',
      description: 'Total',
      credit: credit + '',
      debit: debit + '',
      trx_type: 'TOT'
    });
    const diff = debit - credit;
    debit = 0;
    credit = 0;
    if (diff > 0) {
      credit = diff;
    } else {
      debit = -1 * diff;
    }
    days.push({
      id: '-1',
      req_date: '',
      description: 'Difference',
      credit: credit + '',
      debit: debit + '',
      trx_type: 'TOT'
    });
    return days;
  }
}
