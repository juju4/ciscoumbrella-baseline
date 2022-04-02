# frozen_string_literal: true

# copyright:: 2022, The Authors
# license: All rights reserved

title 'Umbrella section'

umbrella_org_id = input('umbrella_org_id', value: '', description: 'Check Umbrella use the correct Org ID')
umbrella_client = input('umbrella_client', value: false, description: 'Is Umbrella setup with client or anyconnect')
umbrella_client_file = input('umbrella_client_file', value: '/opt/cisco/anyconnect/umbrella/OrgInfo.json', description: 'Umbrella client OrgInfo file path')

control 'umbrella-1.0' do
  impact 1.0
  title 'Umbrella should be setup'
  desc 'Health check should be true'
  only_if { os.family != 'windows' }
  if os.darwin?
    describe command('dig +time=10 debug.opendns.com txt') do
        its('stdout') { should_not match 'Error' }
        its('stderr') { should_not match 'Error' }
        its('stdout') { should match 'organization id' }
        its('stdout') { should match 'dnscrypt enabled' }
        if umbrella_org_id
          its('stdout') { should match "organization id #{umbrella_org_id}" }
        end
      end
  else
    describe command('nslookup -type=txt debug.opendns.com.') do
      its('stdout') { should_not match 'Error' }
      its('stderr') { should_not match 'Error' }
      its('stdout') { should match 'organization id' }
      its('stdout') { should match 'dnscrypt enabled' }
      if umbrella_org_id
        its('stdout') { should match "organization id #{umbrella_org_id}" }
      end
    end
  end
  describe http('https://welcome.umbrella.com/') do
    its('status') { should cmp 200 }
    its('body') { should include 'Welcome to Umbrella!' }
    its('headers.Content-Type') { should cmp 'text/html' }
  end
  describe http('https://examplemalwaredomain.com', ssl_verify: false) do
    its('status') { should cmp 403 }
    its('body') { should include 'location.replace("https://malware.opendns.com' }
    its('headers.Content-Type') { should include 'text/html' }
  end
end

if umbrella_client
  control 'umbrella-2.0' do
    impact 1.0
    title 'Umbrella client should be configured'
    desc 'Ensure Umbrella client config is set'
    only_if { os.family != 'windows' }
    describe file(umbrella_client_file) do
      it { should be_file }
      its('mode') { should cmp '0644' }
      its('content') { should match "\"organizationId\" : \"#{umbrella_org_id}\"" }
      its('content') { should match 'fingerprint' }
      its('content') { should match 'userId' }
    end
  end
end
