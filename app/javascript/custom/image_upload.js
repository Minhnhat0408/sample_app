import { I18n } from 'i18n-js';
import { translations } from '../locales/translations';

const i18n = new I18n();

document.addEventListener('turbo:load', function () {
  const userLocale = window.location.pathname.split('/')[1];
  i18n.store(translations);
  i18n.defaultLocale = 'vi';
  i18n.enableFallback = true;
  i18n.locale = userLocale;
  document.addEventListener('click', function (event) {
    i18n.locale = userLocale;
  });
  document.addEventListener('change', function (event) {
    let image_upload = document.querySelector('#micropost_image');
    if (image_upload && image_upload.files[0]) {
      const size_in_megabytes = image_upload.files[0].size / 1024 / 1024;
      if (size_in_megabytes > 5) {
        alert(i18n.t('a_errors.file_too_large', { size: 5 }));
        image_upload.value = '';
      }
    }
  });
});
