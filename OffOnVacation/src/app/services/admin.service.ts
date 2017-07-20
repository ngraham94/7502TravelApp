import {Injectable} from "@angular/core";
import {AngularFireDatabase} from "angularfire2/database";
/**
 * Created by Nick on 7/11/2017.
 */

@Injectable()

export class AdminService{

  constructor(private database: AngularFireDatabase){}

}
