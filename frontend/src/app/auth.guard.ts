import {Injectable} from '@angular/core';
import {
  CanActivate,
  ActivatedRouteSnapshot,
  RouterStateSnapshot,
  UrlTree,
  Router
} from '@angular/router';
import {Observable} from 'rxjs';
import {NotificationsService} from './utils/notifications';
import {LoginService} from './login.service';

@Injectable({
  providedIn: 'root'
})
export class AuthGuard implements CanActivate {
  constructor(private router: Router, private loginService: LoginService, private notificationsService: NotificationsService) {
  }


  canActivate(
    next: ActivatedRouteSnapshot,
    state: RouterStateSnapshot): Observable<boolean | UrlTree> | Promise<boolean | UrlTree> | boolean | UrlTree {

    // if (this.loginService.isValidUser()) {
    //     //   if (!next.data.roles.includes(this.loginService.getUser().user_type_id + '')) {
    //     //     this.loginService.routeToDefault();
    //     //     this.notificationsService.notice('Sorry.. \nYou dont have access to view this content.');
    //     //     return false;
    //     //   }
    //     //   return true;
    //     // }
    //     // this.router.navigate(['login']);
    //     // return false;

    return true;
  }
}
