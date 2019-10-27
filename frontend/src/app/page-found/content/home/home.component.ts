import {AfterViewInit, Component, OnInit} from '@angular/core';
import {NotificationsService} from '../../../utils/notifications';
import Swal from 'sweetalert2';
import {ActivatedRoute} from '@angular/router';
import {FinanceService} from '../utils/finance.service';
import {HomeService} from './home.service';

declare var $: any;
declare var jQuery: any;

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.scss']
})
export class HomeComponent implements OnInit, AfterViewInit {


  constructor(private route: ActivatedRoute, private homeService: HomeService,
              private notifi: NotificationsService, public financeService: FinanceService) {
  }

  allMembers = 0;
  totalSavings = '0.00';
  totalInBank = '0.00';
  totalInHand = '0.00';

  top5Savers: any[] = [];
  statistics: any;

  connected = true;

  circleColors = ['bg-c-blue d-inline-block text-center',
    'bg-c-pink d-inline-block text-center',
    'bg-c-yellow d-inline-block text-center',
    'bg-c-green d-inline-block text-center',
    'bg-c-red d-inline-block text-center'];

  barColour = [
    'progress-bar bg-c-blue',
    'progress-bar bg-c-pink',
    'progress-bar bg-c-yellow',
    'progress-bar bg-c-green',
    'progress-bar bg-c-red',
  ]

  ngOnInit() {
    this.getTop5Savers();
    this.getStatistics();
  }

  ngAfterViewInit(): void {
  }

  getStatistics() {
    this.connected = true;
    this.statistics = [];
    this.homeService.getStatistics().subscribe((data: any[]) => {
        for (let i = 0; i < data.length; i++) {
          this.statistics[data[i].type] = data[i].amount;
        }
        this.allMembers = this.statistics.member_count;
        this.totalSavings = this.statistics.member_saving_total;
        this.totalInBank = this.statistics.bank_book_total;
        this.totalInHand = (Number(this.totalSavings) - Number(this.statistics.member_loan_total) - Number(this.totalInBank)) + '';
        this.connected = false;
      }, (err) => {
        this.notifi.error('While fetching Statistics');
        this.connected = false;
      }
    );
  }


  getTop5Savers() {
    this.connected = true;
    this.top5Savers = [];
    this.homeService.getTop5Savers().subscribe((data: any) => {
        this.top5Savers = data;
        this.connected = false;
      }, (err) => {
        // this.notifi.error('While fetching Statistics');
        this.connected = false;
      }
    );
  }

  getMemberSharePersantafe(v) {
    v = Number(v) * 100;
    return v / Number(this.totalSavings);
  }

  getTwoLetters(n) {
    const nn = n.toString().toUpperCase().split(' ');
    let v = '';
    for (let i = 0; i < nn.length; i++) {
      v += nn[i][0] + ' ';
    }
    return v.trim();
  }
}
