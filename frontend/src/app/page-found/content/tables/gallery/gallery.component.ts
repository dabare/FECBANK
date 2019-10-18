import {AfterViewInit, Component, OnInit} from '@angular/core';

declare var $: any;
@Component({
  selector: 'app-gallery',
  templateUrl: './gallery.component.html',
  styleUrls: ['./gallery.component.scss']
})
export class GalleryComponent implements OnInit, AfterViewInit {

  constructor() { }

  ngOnInit() {
  }

  ngAfterViewInit(): void {
    $('#lightgallery').lightGallery({thumbnail: true,
      share: false
    });
  }

}
