import {Injectable} from '@angular/core';
import {HttpClient, HttpHeaders} from '@angular/common/http';
import {environment} from 'src/environments/environment.prod';
import {Router} from '@angular/router';
import {Md5} from 'md5-typescript';
import {NotificationsService} from './utils/notifications';

@Injectable({
  providedIn: 'root'
})

export class LoginService {

  constructor(private router: Router, private httpClient: HttpClient,
              private notifi: NotificationsService) {
    if (!this.isValidUser()) {
      this.logout();
    } else {
      this.notifi.success('Welcome ' + this.getUser().name);
    }
  }

  private defaultRutes = {
    13: 'app/dashboard',
    1: 'app/invoice',
    2: 'app/grn-list',
    3: 'app/dashboard',
  };

  private tryingAutoLoging = false;

  public login(username, password) {
    password = this.getHash(password);
    this.loginEndpoint(username, password).subscribe((data: any) => {
        if (data.user.length > 0 && data.user[0].uname === username && data.user[0].pass === password) {
          localStorage.setItem('oidfjntid', JSON.stringify(data));
          this.notifi.info('Login success');
          this.routeToDefault();
        }
      }, (err) => {
        if (err.toString() !== 'Unknown Error') {
          this.notifi.info('Invalid Credentials');
        }
      }
    );
  }

  private autoLogin() {
    this.tryingAutoLoging = true;
    this.loginEndpoint(this.getUser().uname, this.getUser().pass).subscribe((data: any) => {
        if (data.user.length > 0 && data.user[0].uname === this.getUser().uname && data.user[0].pass === this.getUser().pass) {
          localStorage.setItem('oidfjntid', JSON.stringify(data));
          this.notifi.info('Session Refreshed');
        }
        this.tryingAutoLoging = false;
      }, (err) => {
        if (err.toString() !== 'Unknown Error') {
          this.notifi.error('Autologin Failed');
        }
        this.tryingAutoLoging = false;
      }
    );
  }

  public logout() {
    localStorage.removeItem('oidfjntid');
    this.router.navigate(['app/login']);
  }

  public sessionTimeOutRedirectToLogin() {
    this.notifi.info('Your session has expired. Please login again.');
    localStorage.removeItem('oidfjntid');
    // this.router.navigate(['login']);
  }

  public tokenExpiredRedirectToLogin() {
    this.notifi.info('Your token has expired. Please login again.');
    localStorage.removeItem('oidfjntid');
    // this.router.navigate(['login']);
  }

  public isValidUser() {
    return this.isTokenValid();
  }

  public getUser() {
    if (this.isTokenValid()) {
      return JSON.parse(localStorage.getItem('oidfjntid')).user[0];
    } else {
      // this.router.navigate(['app/login']);
      return null;
    }
  }

  public getToken() {
    if (this.isTokenValid()) {
      return JSON.parse(localStorage.getItem('oidfjntid')).token;
    } else {
      return '--';
    }
  }

  public refreshToken() {
    if (this.isTokenValid() && (this.getTokenValidTime() < 60 * 10) && !this.tryingAutoLoging) {
      this.notifi.info('Your session is about to expire. Trying to revalidate...');
      this.autoLogin();
    } else if (!this.isTokenValid()) {
      // this.tokenExpiredRedirectToLogin();
    }
  }

  public routeToDefault() {
    this.router.navigate([this.defaultRutes[this.getUser().privilege_id]]);
    this.notifi.success('Welcome ' + this.getUser().name);
    // document.location.href = location.origin + '/' + this.defaultRutes[this.getUser().privilege_id];
  }

  private loginEndpoint(uname, pass) {
    return this.httpClient.post(environment.apiUrl + '/login', {username: uname, password: pass});
  }

  private hasToken() {
    return JSON.parse(localStorage.getItem('oidfjntid')) != null;
  }

  private getExpirationTime() {
    if (this.hasToken()) {
      return JSON.parse(localStorage.getItem('oidfjntid')).expirationTime;
    } else {
      return null;
    }
  }

  private getTokenValidTime() {
    if (this.hasToken()) {
      return this.getExpirationTime() - Date.now() / 1000;
    } else {
      return -1;
    }
  }

  private isTokenValid() {
    return this.getTokenValidTime() > 0;
  }

  public getHash(str) {
    return Md5.init(str);
  }
}
