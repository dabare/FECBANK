import {Injectable} from '@angular/core';
import {environment} from 'src/environments/environment.prod';
import {HttpClient} from '@angular/common/http';
import {LoginService} from '../../../login.service';

@Injectable({
  providedIn: 'root'
})

export class BankBookService {

  constructor(private httpClient: HttpClient, private loginService: LoginService) {
  }

  getAllBankBookSavings() {
    return this.httpClient.post(environment.apiUrl + '/viewAllBankBookSavings', {});
  }

  insertBankBookSaving(data: any) {
    data.req_user = this.loginService.getUser().id;
    return this.httpClient.post(environment.apiUrl + '/insertBankBookSaving', data);
  }

  cancelBankBookSaving(data: any) {
    data.req_user = this.loginService.getUser().id;
    return this.httpClient.post(environment.apiUrl + '/cancelBankBookSaving', data);
  }

  updateBankBookSaving(data: any) {
    data.req_user = this.loginService.getUser().id;
    return this.httpClient.post(environment.apiUrl + '/updateBankBookSaving', data);
  }
}
