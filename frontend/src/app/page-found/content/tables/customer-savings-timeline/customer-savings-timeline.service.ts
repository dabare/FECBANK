import {Injectable} from '@angular/core';
import {HttpClient, HttpHeaders} from '@angular/common/http';
import {environment} from 'src/environments/environment.prod';
import {LoginService} from '../../../../login.service';

@Injectable({
  providedIn: 'root'
})

export class CustomerSavingsTimelineService {

  constructor(private httpClient: HttpClient, private loginService: LoginService) {
  }

  getCustomerSavingHistory(customer: any) {
    return this.httpClient.post(environment.apiUrl + '/viewMemberSavingHistory', customer);
  }

  insertMemberSaving(data: any) {
    data.req_user = this.loginService.getUser().id;
    return this.httpClient.post(environment.apiUrl + '/insertMemberSaving', data);
  }

  cancelMemberSaving(data: any) {
    data.req_user = this.loginService.getUser().id;
    return this.httpClient.post(environment.apiUrl + '/cancelMemberSaving', data);
  }

  updateMemberSaving(data: any) {
    data.req_user = this.loginService.getUser().id;
    return this.httpClient.post(environment.apiUrl + '/updateMemberSaving', data);
  }

  insertMemberWithdraw(data: any) {
    data.req_user = this.loginService.getUser().id;
    return this.httpClient.post(environment.apiUrl + '/insertMemberWithdraw', data);
  }

  cancelMemberWithdraw(data: any) {
    data.req_user = this.loginService.getUser().id;
    return this.httpClient.post(environment.apiUrl + '/cancelMemberWithdraw', data);
  }

  updateMemberWithdraw(data: any) {
    data.req_user = this.loginService.getUser().id;
    return this.httpClient.post(environment.apiUrl + '/updateMemberWithdraw', data);
  }

}
