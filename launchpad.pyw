import launchpad_py
import sys

LED_COL = 65

lp = launchpad_py.LaunchpadProMk3()
lp.Open()

print("Setting all LEDs to " + str(LED_COL))
lp.LedAllOn(LED_COL)


def quit() -> None:
    print("Exiting")
    lp.Close()
    sys.exit()


while True:
    inp = input()
    match inp:
        case "quit":
            quit()
