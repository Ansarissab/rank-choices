# Ranked Choice Vote

## Prompt

Decide the winner of a ranked-choice election according to the votes in
`votes.csv`.

### Winner decider script instructions
Implemented a class WinnerEvaluator to calculate the winner using `votes.csv`




### Setup from git bundle

> git clone ranked-choice.bundle

### Setup using github repository
> git clone https://github.com/usmanasif/ranked-choice.git



To get the result, run the following command after cloning the project
> cd ranked-choice
> ruby winner_evaluator.rb

### Background

In ranked-choice elections voters specify a prioritized list of their preferred
candidates. After tallying the first-choice votes, the candidate with the fewest
votes is eliminated. The next choice on the ballots for the eliminated candidate
is then given a vote. This process is repeated either until a candidate has a
majority of the votes or only two candidates remain. The candidate with the most
votes at the end of this process wins. You can read [more about ranked-choice
voting](https://en.wikipedia.org/wiki/Instant-runoff_voting) if you are so
inclined, but this description should be sufficient to implement a solution.

### Expectations

- Your script should print out the final distribution of votes for each
  candidate and designate the winner
- Your script can be written in any programming language you'd like
- Your script should be easily runnable by the grader. You may provide
  instructions if necessary
- It is more important that you get to a working solution than a performant
  solution
- The prompt is intended to be completed in less than 2 hours
- Your response should be sent to us by email in either of the following formats:
  - a PRIVATE github repo
  - a tarball or zip of a directory

## Other stuff

Candidates need not worry about what follows for their initial submission, but
may want to review before coming in to interview.

### Extensions

- What stats would you gather and data would you store to prove the legitimacy
  of the result?
  - We will keep track of the votes count in each round
  - We can keep track of how many votes of eliminator candidate is given to other and how many votes are wasted. The vote will be wasted if the voter has only 2 choices and those are eliminated.
- What if results came in in an ongoing basis (streaming inputs)?
  - Batch streams, single vote streams?
  >In both cases, By keeping track of votes count in each round we will not recalculate the votes which are decided in the first choice and will update the votes counts of the particular vote on the basis of the new vote and will recalculate the winner

   >  single vote streams: Yes, If the results are coming in single vote steam inputs, I think we can keep track of two max votes candidate and we can recalculate Winner if there is a difference of 10 votes and we have got 10 new votes one by one. In the one-by-one vote, we will cache the result and will only revaluate part on the basis of the first choice of the voter.

   > Batch streams: In Batch streams, We will use the stored value of votes count in the first round and we will update each round vote counts value on the basis of a new vote

- What if results needed to go out on an ongoing basis (streaming results)?
  - How to do this efficiently?

    > For streaming results, we can use async jobs to decide the winner and the result will be updated asap first async job is completed.
- How does this scale? What if there were 50,000,000 ballots cast?

   > To scale it properly and make it efficient, we will keep the track of vote counts in each round and we will recount the vote only if it's on the eliminator list
