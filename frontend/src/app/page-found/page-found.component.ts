import {AfterViewInit, Component, OnInit} from '@angular/core';
import {LoginService} from '../login.service';

@Component({
  selector: 'app-page-found',
  templateUrl: './page-found.component.html',
  styleUrls: ['./page-found.component.scss']
})
export class PageFoundComponent implements OnInit , AfterViewInit {

  constructor(private loginService: LoginService) { }

  ngOnInit() {
    this.loginService.refreshToken();
  }

  ngAfterViewInit(): void {
  }

}
