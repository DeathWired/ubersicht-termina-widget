format = (->
  '%I:%M'
)()

#brightness 0 - 10
brightness = 7

command: "whoami;date +\"#{format}\";date +%H;pmset -g batt | grep -o '[0-9]*%';hostname -s"

refreshFrequency: 10000

render: (output) -> """
  <div id='terminal'>#{output}</div>
"""

update: (output) ->
    data = output.split('\n')
    
    hashCount = data[3].replace("%", '')/10
    dotCount = 10 - hashCount
    user = data[0]
    hours=data[2]
    device=data[4]
    html = "<div class='wrapper'><div class='watch'><div class='bash'>#{device}:~ #{user}$ date</div><div class='time'>[TIME]<span class='timeData'>"
    html += data[1]
    # html += " "+ampm
    # html += "</span></div><div class='date'>[DATE]<span class='dateData'>"
    # html += data[1]
    html += "</span></div><div class='batt'><span>[BATT]</span><span class='battData'>"
    html += "["
    for i in [0...hashCount]
      html += "#"
    for i in [0...dotCount]
      html +="_"   
    html += "] "
    html += data[3]
    html += "</span></div><div class='bash'>#{device}:~ #{user}$</div></div></div>"

    $(terminal).html(html)
  

style: (->
  return """
    font-size: 15px
    color: white
    line-height: 25px
    width: 100%
    height: 100%
    white-space: nowrap;

    text-shadow: 0 0 #{brightness}px rgba(255,255,255,0.8)

    #terminal
      width: 100%
      height: 100%

    .wrapper
      font-family: Fira Code
      position: absolute
      width: auto
      top: 6%
      left: 8%
      transform: translate(-50%, -50%)

    .watch
      position: absolute
      top: 50%
      transform: translate(-50%, -50%)

    .bash
      font-weight: bold

    .timeData, .dateData, .battData
      margin-left: 10px

    .timeData
      color: rgb(0, 255, 0)
      text-shadow: 0 0 #{brightness}px rgba(0, 255, 0,1)

    .dateData
      color: rgb(255, 0, 255)
      text-shadow: 0 0 #{brightness}px rgba(255, 0, 255,1)

    .battData
      margin-left: 6px
      color: rgb(255, 0, 0)
      text-shadow: 0 0 #{brightness}px rgba(255, 0, 0,1)

  """
)()
