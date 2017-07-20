import { OffOnVacationPage } from './app.po';

describe('off-on-vacation App', () => {
  let page: OffOnVacationPage;

  beforeEach(() => {
    page = new OffOnVacationPage();
  });

  it('should display message saying app works', () => {
    page.navigateTo();
    expect(page.getParagraphText()).toEqual('app works!');
  });
});
