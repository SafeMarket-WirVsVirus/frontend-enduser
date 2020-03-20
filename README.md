# Reservation System

Reservation system for WirVsVirusHackathon

## Sequence diagram

```mermaid
sequenceDiagram
    participant c as customer
    participant s as shop
    participant dl as digitallist
    participant et as entrycontrol
    participant d as datauser
    c->>s: Get shop id
    c->>dl: get ticket for shop id
    loop Notification
        dl->>c: notify entry slot
    end
    c->>et: show ticket to 
    et->>dl: check ticket
    dl->>et: confirm ticket
    et->>dl: Remove from queue
    loop Notification
        d->>dl: retrieve status
    end
```
