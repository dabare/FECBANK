import {Injectable} from '@angular/core';
import {HttpClient, HttpHeaders} from '@angular/common/http';
import {environment} from 'src/environments/environment.prod';
import {LoginService} from '../../../login.service';

@Injectable({
  providedIn: 'root'
})

export class HomeService {
  constructor(private httpClient: HttpClient) {
  }

  getStatistics() {
    return this.httpClient.post(environment.apiUrl + '/getStatistics', {});
  }

  getTop5Savers() {
    return this.httpClient.post(environment.apiUrl + '/getTop5Savers', {});
  }

}
