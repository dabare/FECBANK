import {Injectable} from '@angular/core';
import {environment} from 'src/environments/environment.prod';
import {HttpClient} from '@angular/common/http';
import {LoginService} from '../../../login.service';

@Injectable({
  providedIn: 'root'
})

export class LoansService {

  constructor(private httpClient: HttpClient, private loginService: LoginService) {
  }

  getAllMemberLoans() {
    return this.httpClient.post(environment.apiUrl + '/viewAllMemberLoans', {});
  }

  getDepositsOfLoan(data: any) {
    return this.httpClient.post(environment.apiUrl + '/viewDepositsOfLoan', data);
  }

  insertMemberLoan(data: any) {
    data.req_user = this.loginService.getUser().id;
    return this.httpClient.post(environment.apiUrl + '/insertMemberLoan', data);
  }

  updateMemberLoan(data: any) {
    data.req_user = this.loginService.getUser().id;
    return this.httpClient.post(environment.apiUrl + '/updateMemberLoan', data);
  }

  deleteMemberLoan(data: any) {
    data.req_user = this.loginService.getUser().id;
    return this.httpClient.post(environment.apiUrl + '/deleteMemberLoan', data);
  }

  getAllCustomers() {
    return this.httpClient.post(environment.apiUrl + '/viewAllMembers', {});
  }
}
