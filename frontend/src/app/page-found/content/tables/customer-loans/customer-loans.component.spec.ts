import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import {CustomerLoansComponent} from './loans.component';


describe('LoanPlanComponent', () => {
  let component: CustomerLoansComponent;
  let fixture: ComponentFixture<CustomerLoansComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ CustomerLoansComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(CustomerLoansComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
