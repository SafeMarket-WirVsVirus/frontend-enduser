# SafeMarket

## Features
- Display, create and cancel reservations
- Reminders for reservations
- Search for registered locations and filter results by overall occupancy rate per day
- Display occupancy rate per slot of locations

## Architecture

### Backend and Data Layer

- [Swagger](https://wirvsvirusretail.azurewebsites.net/swagger/ui/index.html) definition of our backend
- `repository`: backend communication as well as persistence
- `repository/data`: model classes

### UI Layer
- `bloc`: state management
- `ui/reservations`: UI elements for reservations tab
- `ui/map`: UI elements for the map tab



