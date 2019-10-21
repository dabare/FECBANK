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


  ngOnInit() {
  }

  ngAfterViewInit(): void {

  }

}
