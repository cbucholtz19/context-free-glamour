# Pokemon master name
name = "Ash Ketchum"

# Pokemon Health Points
charmender_HP = 110
squirtle_HP = 125
bulbasaur_HP = 150

# Pokemon Attack Points
charmender_attack = 40
squirtle_attack = 35
bulbasaur_attack = 25

turn = 1

# Turn-based attack loop, default starts with charmender (turn = 1)
# To change default to Squirtle change set 'turn' to 0
while charmender_HP > 0 and squirtle_HP > 0:
    if turn == 1:
        squirtle_HP -= charmender_attack
        print("Charmender did "+str(charmender_attack)+" damage")
        print("Squirtle got hurt :'( HP is: "+str(squirtle_HP))
        turn = 0
    else:
        charmender_HP -= squirtle_attack
        print("Squirtle faught back and did "+str(squirtle_attack)+" damage")
        print("Charmender got bitten! HP is: "+str(squirtle_HP))
        turn = 1

# Print winner pokemon
if charmender_HP >= 1:
    print(name+"'s Charmender won!")
elif squirtle_HP >=1:
    print(name+"'s Squirtle won!")
else:
    print("Something went wrong!!!")