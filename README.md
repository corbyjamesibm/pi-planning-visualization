# PI Planning Visualization Suite

A collection of interactive D3.js visualizations for SAFe PI (Program Increment) Planning events, developed as part of Sprint 3-4.

## 🎯 Main Visualizations

### 1. PI Planning Event Time-lapse (`PI-PLANNING-EVENT-TIMELAPSE.html`)
**Purpose**: Simulates a realistic 2-day PI Planning event with hourly progression  
**Features**:
- Hourly timeline (32 half-hour increments)
- Feature assignment to teams (all at once, realistic pattern)
- User story decomposition from features
- Dependency emergence and linking
- Force physics simulation with D3.js
- Interactive drag & drop, hover effects, zoom/pan

### 2. Cluster View (`PI-PLANNING-CLUSTER-VIEW.html`)
**Purpose**: Team-based cluster visualization with adjustable spacing  
**Features**:
- Dynamic cluster spacing (100-1000px)
- Preset buttons (Compact, Normal, Spread, Wide)
- Keyboard shortcuts (+/-, F, 0)
- Team focus navigation
- Fit all teams functionality

### 3. Time-Lapse Visualization (`PI-PLANNING-TIME-LAPSE.html`)
**Purpose**: 90-day PI evolution over 6 sprints  
**Features**:
- Daily snapshots with sprint boundaries
- Feature progression tracking
- Animated transitions
- Playback controls with variable speed
- Metrics dashboard

## 🚀 Quick Start

Simply open any HTML file in a modern web browser:

```bash
# Open the main 2-day PI Planning event simulation
open PI-PLANNING-EVENT-TIMELAPSE.html

# Or open the index to see all visualizations
open index.html
```

## 🎮 Controls

### Common Controls (All Visualizations)
- **Mouse wheel**: Zoom in/out
- **Click & drag canvas**: Pan view
- **Click & drag nodes**: Move elements
- **Hover**: Highlight connections
- **Double-click nodes**: Release from fixed position

### Time-lapse Controls
- **Space**: Play/pause animation
- **Arrow keys**: Step forward/backward
- **Speed buttons**: 0.5x, 1x, 2x, 5x playback
- **Timeline slider**: Jump to any point

### Cluster View Controls
- **+/-**: Increase/decrease cluster spacing
- **F**: Fit all teams in view
- **0**: Reset to default spacing

## 📊 Data Model

### Teams
- Platform Services
- Digital Delivery  
- Data Analytics
- Customer Experience
- Infrastructure

### Node Types
- **Teams** (Blue circles) - Fixed anchor points
- **Features** (Yellow) - Assigned to teams
- **User Stories** (Green) - Decomposed from features
- **Dependencies** (Red dashed) - Cross-team linkages

## 🛠️ Technologies Used

- **D3.js v7** - Force simulation and data visualization
- **HTML5/CSS3** - Modern web standards
- **JavaScript ES6+** - Interactive logic
- **SVG** - Scalable vector graphics

## 📈 Performance

- Supports 100+ nodes with smooth 60fps animation
- Frame time: <16ms
- Optimized force simulation parameters
- Efficient DOM updates with D3.js

## 🧪 Test Coverage

Comprehensive E2E test suite with 35 scenarios covering:
- Slider controls
- Preset buttons
- Keyboard shortcuts
- View controls
- Team clustering
- Dependencies
- Performance
- Accessibility
- Integration
- Edge cases

## 📝 Sprint Status

**Sprint 3-4 Achievements**:
- ✅ Adjustable cluster spacing (5 story points)
- ✅ Time-lapse visualization (8 story points)  
- ✅ 2-day PI event simulation (8 story points)
- ✅ Force physics implementation (8 story points)

**Total Completed**: 29 story points

## 🔄 Next Steps

- Complete real-time synchronization (72% done)
- Fix dependency bug fixes (2 high priority)
- Implement mobile touch interface
- Performance testing at scale (100+ concurrent users)

## 📚 Documentation

- Enhancement specifications: See original project docs
- Test documentation: `tests/e2e/cluster-spacing.test.js`
- Sprint reports: Available in project management system

## 🤝 Team

**Development Team**: Platform Services & Digital Delivery  
**Sprint**: 3-4 (Q1 2025)  
**Environment**: Development

---

*These visualizations are standalone HTML files with no external dependencies beyond D3.js (loaded from CDN). They can be deployed to any web server or opened locally.*