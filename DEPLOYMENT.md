# Deployment Guide - PI Planning Visualization Suite

## 🚀 Deployment Options

### Option 1: GitHub Pages (Recommended for Public Access)

The visualizations are automatically deployed to GitHub Pages when pushed to the `gh-pages` branch.

**Live URL**: https://corbyjamesibm.github.io/pi-planning-visualization/

To update the deployed version:
```bash
git checkout gh-pages
git merge main
git push origin gh-pages
```

### Option 2: Local File System

Simply open any HTML file directly in a web browser:
```bash
open visualization-index.html
# Or on Windows: start visualization-index.html
# Or on Linux: xdg-open visualization-index.html
```

### Option 3: Web Server Deployment

#### Apache/Nginx
Copy all HTML files to your web server's document root:
```bash
cp *.html /var/www/html/pi-planning/
```

#### Python Simple Server (for testing)
```bash
python3 -m http.server 8000
# Access at http://localhost:8000
```

#### Node.js HTTP Server
```bash
npx http-server -p 8080
# Access at http://localhost:8080
```

### Option 4: Corporate Intranet

For internal deployment:

1. **SharePoint**: Upload HTML files as document library items
2. **Confluence**: Embed using HTML macro or iframe
3. **Internal Web Server**: Deploy to internal Apache/IIS/Nginx server

### Option 5: Cloud Platforms

#### AWS S3 Static Hosting
```bash
aws s3 cp . s3://your-bucket-name/ --recursive --exclude ".git/*"
aws s3 website s3://your-bucket-name/ --index-document visualization-index.html
```

#### Netlify (Drag & Drop)
1. Visit https://app.netlify.com/drop
2. Drag the entire folder
3. Get instant URL

#### Vercel
```bash
npx vercel
```

#### Azure Static Web Apps
```bash
az staticwebapp create --name pi-planning-viz
az staticwebapp upload --app-name pi-planning-viz
```

## 🔧 Configuration

### Custom Domain Setup (GitHub Pages)

1. Add CNAME file with your domain:
```bash
echo "pi-planning.yourdomain.com" > CNAME
git add CNAME
git commit -m "Add custom domain"
git push origin gh-pages
```

2. Configure DNS:
   - A Record: `185.199.108.153`
   - CNAME: `corbyjamesibm.github.io`

### CORS Considerations

If embedding in other applications, you may need to set CORS headers:

**Apache (.htaccess)**:
```apache
Header set Access-Control-Allow-Origin "*"
```

**Nginx**:
```nginx
add_header 'Access-Control-Allow-Origin' '*';
```

## 🔐 Security Considerations

### For Internal Deployment

1. **Authentication**: Add authentication layer if needed
   ```html
   <!-- Add to HTML head -->
   <script>
   if (!window.location.href.includes('yourdomain.com')) {
       window.location.href = '/login';
   }
   </script>
   ```

2. **HTTPS**: Always use HTTPS in production
   - GitHub Pages: Automatic
   - Self-hosted: Use Let's Encrypt

3. **Content Security Policy**:
   ```html
   <meta http-equiv="Content-Security-Policy" 
         content="default-src 'self' https://d3js.org;">
   ```

## 📦 Dependencies

The visualizations load D3.js from CDN:
```html
<script src="https://d3js.org/d3.v7.min.js"></script>
```

For offline deployment, download D3.js:
```bash
wget https://d3js.org/d3.v7.min.js
# Update HTML files to reference local copy:
# <script src="d3.v7.min.js"></script>
```

## 🔄 Continuous Deployment

### GitHub Actions Workflow

Create `.github/workflows/deploy.yml`:
```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    
    - name: Deploy to GitHub Pages
      uses: peaceiris/actions-gh-pages@v3
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        publish_dir: ./
```

## 🧪 Testing Deployment

### Checklist
- [ ] All visualizations load correctly
- [ ] D3.js force physics work
- [ ] Mouse interactions (drag, zoom, hover) function
- [ ] Playback controls respond
- [ ] No console errors
- [ ] Performance acceptable (60fps animations)

### Browser Compatibility
Tested and working on:
- ✅ Chrome 90+
- ✅ Firefox 88+
- ✅ Safari 14+
- ✅ Edge 90+
- ⚠️ IE11 (limited support)

## 📊 Performance Optimization

### For Large Deployments

1. **Enable Compression**:
   ```nginx
   gzip on;
   gzip_types text/html application/javascript;
   ```

2. **Set Cache Headers**:
   ```apache
   <FilesMatch "\.(html|js|css)$">
     Header set Cache-Control "max-age=3600"
   </FilesMatch>
   ```

3. **Use CDN**:
   - CloudFlare
   - AWS CloudFront
   - Azure CDN

## 🆘 Troubleshooting

### Common Issues

1. **Blank Page**: Check browser console for errors
2. **No Animations**: Ensure D3.js loaded properly
3. **CORS Errors**: Check server headers
4. **Slow Performance**: Reduce node count or disable shadows

### Debug Mode

Add `?debug=true` to URL for verbose logging:
```javascript
if (window.location.search.includes('debug=true')) {
    console.log('Debug mode enabled');
    // Additional logging
}
```

## 📝 Maintenance

### Updating Visualizations

1. Make changes locally
2. Test thoroughly
3. Commit to main branch
4. Deploy to production:
   ```bash
   git push origin main
   git checkout gh-pages
   git merge main
   git push origin gh-pages
   ```

### Monitoring

- Use Google Analytics for usage tracking
- Monitor browser console for errors
- Check performance metrics regularly

## 📧 Support

For deployment issues:
- GitHub Issues: https://github.com/corbyjamesibm/pi-planning-visualization/issues
- Documentation: This file
- Live Demo: https://corbyjamesibm.github.io/pi-planning-visualization/

---

*Last Updated: August 2025*