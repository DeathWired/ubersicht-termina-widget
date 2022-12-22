format = (->
  '%I:%M'
)()

#brightness 0 - 10
brightness = 7
command: "whoami;date +\"#{format}\";date +'%A, %B %d %Y';pmset -g batt | grep -o '[0-9]*%';hostname -s; pmset -g batt | grep -oE \"\'([A-Za-z ]*)\'\""

refreshFrequency: 10000

render: (output) -> """
  <div id='terminal'>#{output}</div>
"""
update: (output) ->
    data = output.split('\n')
    batteries=["","","","","","","","","","","","","","","","","","","","","",""]
    charge = data[3].replace("%", '')
    hashCount=charge/10
    dotCount = 10 - hashCount
    user = data[0]
    device=data[4]
    x=(charge)//10
    colorChange=""
    begin=""
    end=""
    draining=""
    if charge <= 20
      colorChange="red"
    else if charge > 20 && charge < 80
      colorChange="yellow"
    else
      colorChange="Green"
    if charge==100
      end=""
    percent=begin
    for i in [0...hashCount]
      percent += ""
    for i in [0...dotCount]
      percent +=""  
    percent += end
    if data[5] == "'AC Power'"
      x+=11
      draining="<span style='color:green; padding:6px'>⇧</span>"
    else
      draining="<span style='color:red; padding:6px'>⇩</span>"
    html = "<div class='wrapper'>
    <div class='watch'>
        <div class='bash'>#{device}:~ #{user}$</div>
        <div class='time'> #{data[1]}</span></div>
        <div class='batt' style='color: #{colorChange};'><span>#{batteries[x]} #{percent} #{data[3]}</span>#{draining}</div>
        <div class='bash'>#{device}:~ #{user}$</div>
    </div>
</div>"
    $(terminal).html(html)

style: (->
  return """
    font-size: 15px
    color: white
    line-height: 25px
    width: 100%
    height: 100%
    white-space: nowrap;
    text-shadow: 0 0 #{brightness}px rgba(173, 216, 230, 0.5)

    #terminal
      width: 100%
      height: 100%

    .wrapper
      font-family: "FiraCode Nerd Font"
      position: absolute
      width: auto
      transform: translate(-50%, -50%)

    .watch
      position: absolute
      color: #729fff
      margin-left: 15px
      margin-top: 10px

    .bash
      font-weight: bold
      color: rgba(173, 216, 230, 1)
      text-shadow: 0 0 #{brightness}px rgba(173, 216, 230, 1)
    
    .batt
      text-shadow: 0 0 #{brightness}px rgba(173, 216, 230, 0.5)

    .time
      color: orange
      text-shadow: 0 0 #{brightness}px rgba(0,255,0,1)
  """
)()
