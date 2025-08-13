# TargetProcess Integration Guide

## Overview

This guide explains how to integrate the PI Planning Visualizations with TargetProcess for real-time data synchronization and planning capabilities.

## 🔗 Integration Architecture

```
TargetProcess API
        ↓
   MCP Server
        ↓
  Visualization Layer
        ↓
   User Interface
```

## 📊 Data Flow

### 1. Data Import from TargetProcess

The visualizations can be enhanced to pull real data from TargetProcess:

```javascript
// Example: Fetch teams from TargetProcess
async function fetchTeamsFromTP() {
    const response = await fetch('https://your-domain.tpondemand.com/api/v1/Teams', {
        headers: {
            'Authorization': 'Basic ' + btoa('username:password'),
            'Content-Type': 'application/json'
        }
    });
    return response.json();
}

// Example: Fetch features for PI
async function fetchFeaturesForPI(releaseId) {
    const query = `?where=(Release.Id eq ${releaseId})&include=[Name,Team,UserStories]`;
    const response = await fetch(`https://your-domain.tpondemand.com/api/v1/Features${query}`, {
        headers: {
            'Authorization': 'Basic ' + btoa('username:password')
        }
    });
    return response.json();
}
```

### 2. Real-time Updates

Implement WebSocket or polling for real-time synchronization:

```javascript
// Polling approach for real-time updates
function startRealTimeSync(interval = 30000) {
    setInterval(async () => {
        const updates = await fetchLatestChanges();
        updateVisualization(updates);
    }, interval);
}

// WebSocket approach (if supported)
const ws = new WebSocket('wss://your-domain.tpondemand.com/realtime');
ws.on('message', (data) => {
    const update = JSON.parse(data);
    handleRealtimeUpdate(update);
});
```

## 🚀 Quick Start Integration

### Step 1: Configure TargetProcess Connection

Create a configuration file `tp-config.js`:

```javascript
const TP_CONFIG = {
    domain: 'your-domain.tpondemand.com',
    username: 'your-username',
    password: 'your-password', // Or use API token
    apiToken: 'your-api-token',
    releaseId: 123, // Your PI Release ID
    teamIds: [456, 789], // Your team IDs
};
```

### Step 2: Add Data Fetching Layer

Create `tp-data-service.js`:

```javascript
class TargetProcessService {
    constructor(config) {
        this.config = config;
        this.baseUrl = `https://${config.domain}/api/v1`;
    }

    async getHeaders() {
        return {
            'Authorization': this.config.apiToken 
                ? `Bearer ${this.config.apiToken}`
                : `Basic ${btoa(`${this.config.username}:${this.config.password}`)}`,
            'Content-Type': 'application/json'
        };
    }

    async getTeams() {
        const response = await fetch(`${this.baseUrl}/Teams`, {
            headers: await this.getHeaders()
        });
        return response.json();
    }

    async getFeatures(releaseId) {
        const query = `?where=(Release.Id eq ${releaseId})&include=[Id,Name,Team,EntityState]`;
        const response = await fetch(`${this.baseUrl}/Features${query}`, {
            headers: await this.getHeaders()
        });
        return response.json();
    }

    async getUserStories(featureId) {
        const query = `?where=(Feature.Id eq ${featureId})&include=[Id,Name,Team,EntityState]`;
        const response = await fetch(`${this.baseUrl}/UserStories${query}`, {
            headers: await this.getHeaders()
        });
        return response.json();
    }

    async getDependencies() {
        const query = `?include=[Id,Master,Slave,DependencyType]`;
        const response = await fetch(`${this.baseUrl}/Dependencies${query}`, {
            headers: await this.getHeaders()
        });
        return response.json();
    }
}
```

### Step 3: Transform TargetProcess Data

Create `tp-data-transformer.js`:

```javascript
class DataTransformer {
    static transformToVisualizationFormat(tpData) {
        const nodes = [];
        const links = [];

        // Transform teams
        tpData.teams.forEach(team => {
            nodes.push({
                id: `team-${team.Id}`,
                name: team.Name,
                type: 'team',
                x: Math.random() * 800,
                y: Math.random() * 600
            });
        });

        // Transform features
        tpData.features.forEach(feature => {
            nodes.push({
                id: `feature-${feature.Id}`,
                name: feature.Name,
                type: 'feature',
                teamId: feature.Team?.Id,
                state: feature.EntityState?.Name
            });

            // Link to team
            if (feature.Team) {
                links.push({
                    source: `team-${feature.Team.Id}`,
                    target: `feature-${feature.Id}`,
                    type: 'assignment'
                });
            }
        });

        // Transform user stories
        tpData.userStories.forEach(story => {
            nodes.push({
                id: `story-${story.Id}`,
                name: story.Name,
                type: 'story',
                teamId: story.Team?.Id,
                state: story.EntityState?.Name
            });

            // Link to feature
            if (story.Feature) {
                links.push({
                    source: `feature-${story.Feature.Id}`,
                    target: `story-${story.Id}`,
                    type: 'decomposition'
                });
            }
        });

        // Transform dependencies
        tpData.dependencies.forEach(dep => {
            links.push({
                source: `story-${dep.Master.Id}`,
                target: `story-${dep.Slave.Id}`,
                type: 'dependency'
            });
        });

        return { nodes, links };
    }
}
```

### Step 4: Integrate with Visualizations

Update your visualization HTML files to use real data:

```javascript
// In PI-PLANNING-EVENT-TIMELAPSE.html
async function loadRealData() {
    const tpService = new TargetProcessService(TP_CONFIG);
    
    // Fetch all data
    const [teams, features, stories, dependencies] = await Promise.all([
        tpService.getTeams(),
        tpService.getFeatures(TP_CONFIG.releaseId),
        Promise.all(features.map(f => tpService.getUserStories(f.Id))).then(s => s.flat()),
        tpService.getDependencies()
    ]);

    // Transform to visualization format
    const visualizationData = DataTransformer.transformToVisualizationFormat({
        teams,
        features,
        userStories: stories,
        dependencies
    });

    // Update visualization
    updateVisualization(visualizationData);
}

// Replace mock data with real data
document.addEventListener('DOMContentLoaded', () => {
    loadRealData().catch(error => {
        console.error('Failed to load TargetProcess data:', error);
        // Fall back to mock data
        loadMockData();
    });
});
```

## 🔄 Bi-directional Updates

### Writing Changes Back to TargetProcess

```javascript
// Update story assignment
async function updateStoryAssignment(storyId, teamId) {
    const response = await fetch(`${baseUrl}/UserStories/${storyId}`, {
        method: 'POST',
        headers: await getHeaders(),
        body: JSON.stringify({
            Team: { Id: teamId }
        })
    });
    return response.json();
}

// Create dependency
async function createDependency(masterId, slaveId, type = 'Blocks') {
    const response = await fetch(`${baseUrl}/Dependencies`, {
        method: 'POST',
        headers: await getHeaders(),
        body: JSON.stringify({
            Master: { Id: masterId },
            Slave: { Id: slaveId },
            DependencyType: { Name: type }
        })
    });
    return response.json();
}
```

## 🔐 Security Considerations

### 1. API Token Management

Never hardcode credentials in production:

```javascript
// Use environment variables or secure config
const config = {
    apiToken: process.env.TP_API_TOKEN || prompt('Enter TargetProcess API Token:')
};
```

### 2. CORS Configuration

For client-side integration, configure CORS in TargetProcess or use a proxy:

```javascript
// Proxy server example (Node.js)
app.use('/tp-api', createProxyMiddleware({
    target: 'https://your-domain.tpondemand.com',
    changeOrigin: true,
    pathRewrite: { '^/tp-api': '/api/v1' },
    headers: {
        'Authorization': `Bearer ${process.env.TP_API_TOKEN}`
    }
}));
```

## 📈 Performance Optimization

### 1. Data Caching

```javascript
class CachedTPService extends TargetProcessService {
    constructor(config) {
        super(config);
        this.cache = new Map();
        this.cacheTimeout = 60000; // 1 minute
    }

    async cachedFetch(key, fetchFn) {
        const cached = this.cache.get(key);
        if (cached && Date.now() - cached.timestamp < this.cacheTimeout) {
            return cached.data;
        }
        
        const data = await fetchFn();
        this.cache.set(key, { data, timestamp: Date.now() });
        return data;
    }

    async getTeams() {
        return this.cachedFetch('teams', () => super.getTeams());
    }
}
```

### 2. Pagination for Large Datasets

```javascript
async function* fetchAllPages(entityType, query = '') {
    const pageSize = 100;
    let skip = 0;
    
    while (true) {
        const response = await fetch(
            `${baseUrl}/${entityType}?${query}&take=${pageSize}&skip=${skip}`,
            { headers: await getHeaders() }
        );
        const data = await response.json();
        
        if (!data.Items || data.Items.length === 0) break;
        
        yield data.Items;
        skip += pageSize;
    }
}

// Usage
async function getAllFeatures() {
    const allFeatures = [];
    for await (const batch of fetchAllPages('Features', 'where=(Release.Id eq 123)')) {
        allFeatures.push(...batch);
    }
    return allFeatures;
}
```

## 🧪 Testing Integration

### Mock TargetProcess Server

```javascript
// mock-tp-server.js
class MockTPServer {
    constructor() {
        this.data = {
            teams: [
                { Id: 1, Name: 'Platform Services' },
                { Id: 2, Name: 'Digital Delivery' }
            ],
            features: [
                { Id: 101, Name: 'User Authentication', Team: { Id: 1 } },
                { Id: 102, Name: 'Payment Processing', Team: { Id: 2 } }
            ]
        };
    }

    async getTeams() {
        return Promise.resolve({ Items: this.data.teams });
    }

    async getFeatures() {
        return Promise.resolve({ Items: this.data.features });
    }
}

// Use mock in development
const tpService = process.env.NODE_ENV === 'production' 
    ? new TargetProcessService(config)
    : new MockTPServer();
```

## 🚢 Deployment Options

### 1. Standalone with API Proxy

Deploy visualizations with a lightweight proxy server:

```javascript
// server.js
const express = require('express');
const { createProxyMiddleware } = require('http-proxy-middleware');

const app = express();

// Serve static files
app.use(express.static('public'));

// Proxy TargetProcess API
app.use('/api/tp', createProxyMiddleware({
    target: process.env.TP_DOMAIN,
    changeOrigin: true,
    headers: {
        'Authorization': `Bearer ${process.env.TP_API_TOKEN}`
    }
}));

app.listen(3000);
```

### 2. Embedded in TargetProcess

Use TargetProcess Mashups for direct integration:

```javascript
// mashup.js
tau.mashups
    .addDependency('jQuery')
    .addMashup(function($, config) {
        // Your visualization code here
        const vizContainer = $('<div id="pi-planning-viz"></div>');
        $('.tau-board').append(vizContainer);
        
        // Load D3.js and initialize
        $.getScript('https://d3js.org/d3.v7.min.js', () => {
            initializeVisualization('#pi-planning-viz');
        });
    });
```

### 3. Using MCP Server

Leverage the TargetProcess MCP server for enhanced integration:

```javascript
// Connect to MCP server
const mcpClient = new MCPClient({
    server: 'localhost:3000',
    tools: ['search_entities', 'get_entity', 'create_entity']
});

// Use MCP tools
async function loadPIData() {
    const features = await mcpClient.call('search_entities', {
        type: 'Feature',
        where: `Release.Id = ${releaseId}`
    });
    
    return features;
}
```

## 📚 Additional Resources

- [TargetProcess REST API Documentation](https://dev.targetprocess.com/docs/rest-api)
- [TargetProcess WebSocket API](https://dev.targetprocess.com/docs/websocket-api)
- [D3.js Documentation](https://d3js.org/)
- [MCP Server Documentation](../README.md)

## 🆘 Troubleshooting

### Common Issues

1. **CORS Errors**: Use a proxy server or configure TargetProcess CORS settings
2. **Authentication Failures**: Verify API token permissions
3. **Performance Issues**: Implement caching and pagination
4. **Data Sync Delays**: Adjust polling intervals or use WebSockets

### Debug Mode

Enable debug logging:

```javascript
const DEBUG = true;

function debugLog(...args) {
    if (DEBUG) console.log('[TP Integration]', ...args);
}
```

## 📧 Support

For integration support:
- TargetProcess API: support@targetprocess.com
- Visualization Issues: Create GitHub issue
- MCP Server: See main documentation

---

*Last Updated: August 2025*