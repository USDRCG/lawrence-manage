# Info

## Account
We use the account named 'hpc_workshop'.  Add users to it before the workshop
starts, remove them from it when it ends.


## Reservation
Create a reservation for the workshop, make it magnetic and associate it with
the 'workshop' account.  Then any workshop users shoudl get their jobs placed
into that reservation, giving them priority over other jobs in the system.

Reservation creation command:

scontrol create reservation reservationname="2023-11-16-workshop" nodecnt=5 starttime=2023-11-16T13:00:00 duration=5:00:00 accounts=hpc_workshop flags=magnetic

Tweak for use
