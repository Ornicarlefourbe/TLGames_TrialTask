# Question 5

For this question, I added a spell by creating the frigo.lua script, in server/data/spells/scripts/attack. I then modified server/data/spells/spells.xml to set the spell. 

I took the approach to make the patterns random. I first declare AREA_FRIGOPOTENTIAL, which represents every place that CAN be a damaging place during the spell. Then I generate the whole pattern, and play it when the spell is casted.
The issue with this approach is that the patterns are randomized at server startup, and they will remain the same during the server lifetime. So the spell is not random at every cast.