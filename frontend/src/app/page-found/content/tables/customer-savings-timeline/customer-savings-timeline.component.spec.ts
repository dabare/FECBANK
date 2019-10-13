import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import {CustomerSavingsTimelineComponent} from './customer-savings-timeline.component';


describe('CustomerComponent', () => {
  let component: CustomerSavingsTimelineComponent;
  let fixture: ComponentFixture<CustomerSavingsTimelineComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ CustomerSavingsTimelineComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(CustomerSavingsTimelineComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
