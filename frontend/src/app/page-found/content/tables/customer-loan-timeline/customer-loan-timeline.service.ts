import {Injectable} from '@angular/core';
import {HttpClient, HttpHeaders} from '@angular/common/http';
import {environment} from 'src/environments/environment.prod';
import {LoginService} from '../../../../login.service';

@Injectable({
  providedIn: 'root'
})

export class CustomerLoanTimelineService {

  constructor(private httpClient: HttpClient, private loginService: LoginService) {
  }

  getDepositsOfLoan(data: any) {
    return this.httpClient.post(environment.apiUrl + '/viewDepositsOfLoan', data);
  }

  cancelMemberLoanDeposit(data: any) {
    data.req_user = this.loginService.getUser().id;
    return this.httpClient.post(environment.apiUrl + '/cancelMemberLoanDeposit', data);
  }

  completeMemberLoanDeposit(data: any) {
    data.req_user = this.loginService.getUser().id;
    return this.httpClient.post(environment.apiUrl + '/completeMemberLoanDeposit', data);
  }

  insertMemberLoanDeposit(data: any) {
    data.req_user = this.loginService.getUser().id;
    return this.httpClient.post(environment.apiUrl + '/insertMemberLoanDeposit', data);
  }
}
