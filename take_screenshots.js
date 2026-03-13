const puppeteer = require('puppeteer');
const path = require('path');

(async () => {
  const browser = await puppeteer.launch({
    args: ['--no-sandbox', '--disable-setuid-sandbox']
  });
  const page = await browser.newPage();
  await page.setViewport({ width: 1200, height: 1000 });
  
  const url = 'http://76.13.181.119:8082/';
  const screenshotPath = '/data/.openclaw/workspace-dev/ios-cleanup-pro/screenshots';

  console.log('Navigating to', url);
  await page.goto(url, { waitUntil: 'networkidle2' });

  // 1. Home Screenshot (Chinese)
  await page.screenshot({ path: path.join(screenshotPath, 'home_zh.jpg'), type: 'jpeg' });
  console.log('Saved home_zh.jpg');

  // 2. Switch to Screenshots Tab
  await page.click('button[onclick="showTab(\'screenshots\')"]');
  await new Promise(r => setTimeout(r, 500));
  await page.screenshot({ path: path.join(screenshotPath, 'screenshots_zh.jpg'), type: 'jpeg' });
  console.log('Saved screenshots_zh.jpg');

  // 3. Switch to Videos Tab
  await page.click('button[onclick="showTab(\'videos\')"]');
  await new Promise(r => setTimeout(r, 500));
  await page.screenshot({ path: path.join(screenshotPath, 'videos_zh.jpg'), type: 'jpeg' });
  console.log('Saved videos_zh.jpg');

  // 4. Switch Language to English
  await page.click('button.lang-btn');
  await new Promise(r => setTimeout(r, 500));
  
  // 5. Home Screenshot (English)
  await page.click('button[onclick="showTab(\'home\')"]');
  await new Promise(r => setTimeout(r, 500));
  await page.screenshot({ path: path.join(screenshotPath, 'home_en.jpg'), type: 'jpeg' });
  console.log('Saved home_en.jpg');

  await browser.close();
})();
