import {Injectable} from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {MiddlewareService} from '../../../middleware.service';

@Injectable({
  providedIn: 'root'
})

export class SystemSettingsService {

  constructor(private httpClient: HttpClient, private middlewareService: MiddlewareService) {
  }

  getCusPoints() {
    return this.middlewareService.select('getCusPoints', '', '', '');
  }

  getSupPoints() {
    return this.middlewareService.select('getSupPoints', '', '', '');
  }

  getProdPoints() {
    return this.middlewareService.select('getProdPoints', '', '', '');
  }

}
