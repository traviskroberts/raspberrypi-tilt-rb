tilt_mac_addr = 'xx:xx:xx:xx:xx:xx' # PUT YOUR TILT'S MAC ADDRESS HERE
script_path '/var/www/html' # PUT THE PATH TO THE SCRIPT HERE

begin
  retries ||= 0

  bt_devices = `python #{script_path}/tiltblescan.py`
  tilt_entry = bt_devices.match(/#{tilt_mac_addr}.*/)

  raise if tilt_entry.length == 0

  pieces = tilt_entry[0].split(',')
  temp = pieces[2]
  sg = sprintf('%0.03f', (pieces[3].to_f / 1000)) # precision will always be 3

  # make request to API with sg/temp
  puts "SG: #{sg}"
  puts "Temp: #{temp}"
rescue
  if retries < 5
    retries += 1
    sleep 2 ** retries
    retry
  end
end
