# Cisco Umbrella DNS InSpec Profile

Ensure Cisco Umbrella DNS is setup, configured and active on Linux or MacOS system.
It can be through
* just DNS nameservers (Upstream or Umbrella Virtual Appliances)
* Umbrella Client
* Anyconnect VPN client

```
% inspec exec ciscoumbrella-baseline
% inspec exec ciscoumbrella-baseline -t ssh://user@hostname
```

# References

* https://umbrella.cisco.com/
* https://support.umbrella.com/hc/en-us/articles/234692027-Umbrella-Diagnostic-Tool
* https://docs.umbrella.com/umbrella-user-guide/docs/test-your-destinations
* debug.opendns.com remoteip should map to Umbrella VA
