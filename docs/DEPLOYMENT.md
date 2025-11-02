# Deployment Guide

## Production Deployment Checklist

### Backend Deployment (Heroku/Railway)

1. **Environment Setup**
   ```bash
   heroku create titweng-api
   heroku addons:create heroku-postgresql:hobby-dev
   heroku config:set DATABASE_URL=postgresql://...
   ```

2. **Required Environment Variables**
   ```env
   DATABASE_URL=postgresql://...
   ADMIN_USERNAME=admin
   ADMIN_PASSWORD=secure_password
   JWT_SECRET=your-jwt-secret
   BREVO_API_KEY=your-brevo-key
   SMTP_FROM_EMAIL=your-email@gmail.com
   ```

3. **Deploy**
   ```bash
   git subtree push --prefix backend heroku main
   ```

### Frontend Deployment (Vercel)

1. **Build Configuration**
   ```bash
   cd admin_dashboard
   npm run build
   ```

2. **Deploy to Vercel**
   ```bash
   vercel --prod
   ```

3. **Environment Variables**
   ```env
   VITE_API_URL=https://titweng-api.herokuapp.com
   ```

### Mobile App Distribution

1. **Android APK**
   ```bash
   flutter build apk --release
   ```

2. **iOS Build**
   ```bash
   flutter build ios --release
   ```

## Monitoring and Maintenance

- Health checks: `/health` endpoint
- Logs: Heroku logs or application monitoring
- Database backups: Automated daily backups
- SSL certificates: Auto-renewal via Let's Encrypt