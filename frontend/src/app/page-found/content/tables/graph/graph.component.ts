import {AfterViewInit, Component, Input, OnChanges, OnInit, SimpleChanges} from '@angular/core';

declare var Morris: any;

@Component({
  selector: 'app-graph',
  templateUrl: './graph.component.html',
  styleUrls: ['./graph.component.scss']
})
export class GraphComponent implements OnInit, AfterViewInit, OnChanges {

  @Input()
  chartData: any[];

  @Input()
  yKeys: any[];

  @Input()
  yLables: any[];

  @Input()
  yColors: any[] = ['#FF9F55'];

  @Input()
  xKey: string;


  private graph: any;

  constructor() { }

  ngOnInit() {
  }

  ngAfterViewInit() {
    this.drawChart();
  }

  ngOnChanges(changes: SimpleChanges): void {
      // this.drawChart();
  }


  private drawChart() {
    if (!this.graph) {
      this.graph = Morris.Line({
        element: 'time-graph',
        data: this.chartData,
        xkey: 'req_date',
        redraw: true,
        ykeys: this.yKeys,
        hideHover: 'auto',
        labels: this.yLables,
        lineColors: this.yColors
      }).on('click',  (i, row) => {
        // Do your actions
        // Example:
        console.log(i);
      });
    } else {
      this.graph.setData(this.chartData);
      this.graph.redraw();
    }
  }
}
