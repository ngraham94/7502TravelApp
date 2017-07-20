import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { HttpModule } from '@angular/http';
import {BrowserAnimationsModule} from '@angular/platform-browser/animations';
import {MdToolbarModule, MdSidenavModule, MdButtonModule} from '@angular/material';
import { AngularFireModule} from 'angularfire2';
import { RouterModule, Routes } from '@angular/router';

import 'hammerjs';

import { AppComponent } from './app.component';

export const firebaseConfig = {
  apiKey: "AIzaSyC49QmdF90QrbRyx_2eMR9NA4kImLfW1kU",
  authDomain: "offonvacation-448b4.firebaseapp.com",
  databaseURL: "https://offonvacation-448b4.firebaseio.com",
  storageBucket: "offonvacation-448b4.appspot.com",
  messagingSenderId: "40101358931"
};

@NgModule({
  declarations: [
    AppComponent
  ],
  imports: [
    BrowserModule,
    BrowserAnimationsModule,
    FormsModule,
    HttpModule,
    MdToolbarModule,
    MdSidenavModule,
    MdButtonModule,
    AngularFireModule.initializeApp(firebaseConfig),
    RouterModule,
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
