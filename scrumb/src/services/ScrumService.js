import axios from 'axios';

import ScrumActions from '../actions/ScrumActions';
import { SCRUMS_URL } from '../constants/ScrumConstants';
import AuthStore from '../stores/AuthStore';

class ScrumService {
  getScrums() {
    let self = this;
    /*
    axios.get(SCRUMS_URL, {
      headers: {
        Authorization: AuthStore.jwt,
        'Content-Type': 'application/json'
      }
    */
    axios({
      method: 'GET',
      url: SCRUMS_URL,
      headers: {
        'Authorization': AuthStore.jwt,
        'Content-Type': 'application/json'
      }
    }).then(function(response) {
      // console.log(response);
      self.getScrum(response.data[0].id);
      ScrumActions.gotScrums(response.data);
    }).catch(function(error) {
      console.error(error);
    });
  }

  getScrum(id) {
    axios({
      method: 'GET',
      url: `${SCRUMS_URL}/${id}`,
      headers: {
        'Authorization': AuthStore.jwt,
        'Content-Type': 'application/json'
      }
    }).then(function(response) {
      // console.log(response.data);
      ScrumActions.gotScrum(response.data);
    }).catch(function(error) {
      console.error(error);
    });
  }

  getToday(id) {
    axios({
      method: 'GET',
      url: `${SCRUMS_URL}/${id}/today`,
      headers: {
        Authorization: AuthStore.jwt,
        'Content-Type': 'application/json'
      }
    }).then(function(response) {
      // console.log(JSON.stringify(response.data));
      ScrumActions.gotToday(response.data);
    }).catch(function(error) {
      console.error(error);
    });
  }

  invalidateToday() {
    ScrumActions.invalidateToday();
  }
}

export default new ScrumService();
