import {AngularFireDatabase, FirebaseListObservable} from "angularfire2/database";
import {Injectable} from "@angular/core";
/**
 * Created by Nick on 7/11/2017.
 */

@Injectable()
export class SurveyService {
  db: AngularFireDatabase;
  pendingSurveys: FirebaseListObservable<any>;

  constructor(db: AngularFireDatabase) {
    this.db = db
  }

  submitSurvey(survey: Object) {
    survey['pending'] ='yes';
    survey['id'] = 'anID';
    this.db.list('/surveys').push(survey);
  }

  retreivePendingSurveys(){
    this.db.list('/items', {
      query:{
        orderByChild: 'survey/pending',
        equalTo: 'yes'
      }
    })
  }

  markSurveyAsRead(surveyId: string){}

  purgeSurveys(){

  }
}
