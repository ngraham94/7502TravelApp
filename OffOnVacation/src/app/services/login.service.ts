/**
 * Created by Nick on 7/11/2017.
 */
import {Injectable} from "@angular/core";
import { AngularFireAuth} from 'angularfire2/auth'
import * as firebase from 'firebase/app'

@Injectable()
export class LoginService {
  cookie: any;

  constructor(public afAuth: AngularFireAuth) {
  }

  loginWithServer() {
    //TO-DO
}

  loginWithGoogle() {
    this.afAuth.auth.signInWithPopup(new firebase.auth.GoogleAuthProvider());
  }

  logout() {
    return this.afAuth.auth.signOut();
  }
}
