import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import {CustomerLoanTimelineComponent} from './customer-loan-timeline.component';


describe('CustomerComponent', () => {
  let component: CustomerLoanTimelineComponent;
  let fixture: ComponentFixture<CustomerLoanTimelineComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ CustomerLoanTimelineComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(CustomerLoanTimelineComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
