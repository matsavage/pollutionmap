import requests
import pandas as pd
import json

url = 'https://api.openaq.org/v1/latest?city=London&has_geo'

r = requests.get(url)
json_data = r.json()

out = pd.DataFrame([])
var =  pd.DataFrame([])

for i in range (0, len(json_data['results'])):
    lat = float(json_data['results'][i]['coordinates']['latitude'])
    lon = float(json_data['results'][i]['coordinates']['longitude'])
    out = out.append(pd.DataFrame({'latitude' : lat, 'longitude': lon}, index = [i]))

    for j in range(0, len(json_data['results'][i]['measurements'])):
        par = str((json_data['results'][i]['measurements'][j]['parameter']))
        val = float(json_data['results'][i]['measurements'][j]['value'])
        var = var.append(pd.DataFrame({par : val}, index = [i]))
        #out = out.append(pd.DataFrame({var : val}, index = [i]))
        
var = var.groupby(level=0).sum()
out = out. join(var)


out.to_csv('latest.csv')    


