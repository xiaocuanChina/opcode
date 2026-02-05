import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';
import { zhCN } from '@/locales/zh-CN/translation';
import { enUS } from '@/locales/en-US/translation';

const resources = {
  'zh-CN': {
    translation: zhCN
  },
  'en-US': {
    translation: enUS
  }
};

i18n
  .use(initReactI18next)
  .init({
    resources,
    lng: 'zh-CN', // 默认中文
    fallbackLng: 'en-US',

    interpolation: {
      escapeValue: false, // React already safes from xss
    },

    // 检测浏览器语言
    detection: {
      order: ['localStorage', 'navigator'],
      caches: ['localStorage']
    }
  });

export default i18n;