# One Leaked Secret Changed the Way I Build Software

> *"Good judgment comes from experience. Experience usually comes from bad judgment."*

Yesterday, I leaked a secret.

Not my proudest engineering moment.

Fortunately, it wasn't catastrophic. The credential was rotated within minutes, the repository history was cleaned up, and after spending a few minutes questioning my life choices, everything was back under control.

In the grand scheme of things, it wasn't a disaster.

It was simply one of those moments that reminds you you're still human.

If you've been writing software long enough, you've probably deleted the wrong database, merged into the wrong branch, deployed on a Friday afternoon, or accidentally exposed something that should have remained private. We all collect those scars eventually. Some become funny stories. Some become expensive lessons. The best ones become something even more valuable: motivation to build better systems.

That's exactly what happened here.

The leak itself wasn't what kept me thinking that evening.

Mistakes happen.

What bothered me was something much more fundamental.

I've spent years automating repetitive engineering work. I automate releases. I automate versioning. I automate Homebrew packaging. I automate documentation. I automate infrastructure. I automate the boring parts because I'd much rather spend my time building software than remembering checklists.

Yet somehow, one of the most repetitive workflows in my day was still almost entirely dependent on memory.

Mine.

That realization bothered me far more than the leaked secret ever did.

---

## It Started With a Simple Question

Later that evening I found myself staring at one of my repositories and asking a question that, in hindsight, I should have asked years ago.

*Why am I still building repositories by hand?*

Not applications.

Repositories.

They're very different things.

Applications should be unique. Every project solves a different problem.

Repositories shouldn't.

Every new repository I create starts with almost exactly the same routine. Initialize Git. Create a README. Pick a license. Add a `.gitignore`. Configure GitHub Actions. Enable Dependabot. Create issue templates. Configure release automation. Add documentation. Configure ownership. Enable security features.

The application changes every time.

The surrounding engineering rarely does.

At some point I realized I had developed a ritual. Whenever I started a new project, I'd inevitably open an older repository in another window — not because I wanted to look at the code, but because I wanted to copy everything *around* the code.

- `README`
- `LICENSE`
- `CHANGELOG`
- GitHub workflows
- Issue templates
- Pull request template
- `CODEOWNERS`
- Dependabot
- Editor configuration
- Release documentation

It worked.

But every time I did it, it felt a little strange.

I wasn't engineering anymore.

I was performing administration.

And computers happen to be remarkably good at administration.

---

## A Tool That Slowly Outgrew Its Original Purpose

A couple of years ago I built a small Bash utility called `commit_gh`.

At the time it had a very modest goal.

I was releasing quite a few small command-line tools, and I kept finding myself doing the same dance over and over again. Commit the changes. Update the version. Create the Git tag. Push everything. Publish the release. Update Homebrew. Double-check that I hadn't forgotten anything important.

Most of the time I hadn't.

Occasionally I had.

Those were usually the releases that required another release five minutes later.

There wasn't anything particularly difficult about the process.

It was simply repetitive.

And repetitive work has an interesting property. The first time you do it, you're paying attention. The hundredth time you're relying almost entirely on muscle memory. That's usually when little mistakes start creeping in.

So I did what most engineers eventually do when repetition becomes annoying enough.

I automated it.

`commit_gh` started life as nothing more than a release helper. One command that handled semantic versioning, Git tags, version files, GitHub releases, and all the repetitive plumbing that comes with publishing software.

It wasn't trying to replace Git.

It certainly wasn't trying to become a CI/CD platform.

It simply made releasing software feel… calmer.

Over time I started using it for every project. Every Homebrew package. Every experiment. Every side project.

Eventually I reached the point where releasing software without it felt uncomfortable.

Looking back, I think that's where something interesting started happening.

Without consciously planning it, I had stopped automating Git commands.

I had started automating engineering habits.

---

## Yesterday Changed the Direction

The leaked secret didn't convince me to install Gitleaks.

I'd already used it before.

It didn't convince me to take security seriously.

I've always taken security seriously.

What it did convince me of was something much simpler.

I was solving the wrong problem.

For years I'd been focusing on making releases easier. Yesterday made me realize I should have been focusing on making repositories *better* from the very beginning.

The first commit is arguably the most important one a repository will ever receive.

It defines the standards for everything that follows.

- Documentation
- Ownership
- Automation
- Security
- Release engineering

Those aren't things I should remember to add later.

They should already be there before the first real line of code is ever committed.

That realization fundamentally changed what `commit_gh` is.

Today it still handles releases. It still manages versioning. It still creates GitHub releases. But somewhere along the way it quietly evolved into something much bigger.

It became my opinionated way of saying:

> *"This is what I believe every repository should look like before development even begins."*

And once I started looking at it that way, almost every engineering decision became surprisingly obvious.

---

## Good Systems Assume Humans Will Forget

One thing I've learned over the years is that software rarely fails because people are stupid.

It usually fails because people are busy.

There's a difference.

Nobody wakes up in the morning thinking, *"Today feels like a good day to accidentally commit a production credential."*

It happens because you're switching between five projects, answering Slack messages, helping a colleague debug something, reviewing a pull request, and trying to squeeze one last commit in before dinner.

That's when experience quietly hands the steering wheel to habit.

Usually that's a good thing.

Sometimes it isn't.

Yesterday was one of those days.

As I was cleaning everything up, I caught myself thinking about something we say often in infrastructure and platform engineering.

*Design for failure.*

We talk about it all the time.

Servers fail. Networks fail. Disks fail. Availability zones fail. Entire cloud regions occasionally decide they've had enough for the day.

We happily build redundant systems because we assume one component will eventually disappoint us.

So why don't we design our daily engineering workflow with exactly the same assumption?

Why do we assume the human is somehow the one component that will never make a mistake?

That seemed… inconsistent.

Maybe the better approach wasn't to trust myself more.

Maybe it was to trust myself less.

Not because I'm careless.

Because I'm human.

There's a subtle but important difference.

---

## One Safety Net Is Rarely Enough

Once I started thinking about it that way, the next design decision became surprisingly obvious.

One security check isn't really a strategy.

It's hope.

If that one check fails, or gets bypassed, or simply doesn't detect what it's supposed to detect, there isn't another opportunity to stop the mistake.

Infrastructure doesn't work that way. Neither does aviation. Neither does medicine.

The best systems don't rely on one perfect defence.

They rely on several imperfect ones that overlap.

That's the philosophy I ended up building into `commit_gh`.

Not because I distrust developers.

Because I trust reality.

### Layer One: The Filename Check

The first layer is intentionally simple.

Sometimes you don't need pattern matching, entropy calculations, or machine learning. Sometimes the filename tells you everything you need to know.

If I'm trying to commit a file called `.env`, `id_rsa`, `production.pem`, `.vault.production`, or anything else that obviously contains secrets, I don't need sophisticated analysis.

I need someone to tap me on the shoulder and say, *"Are you absolutely sure you meant to do that?"*

That happens before Git even starts creating the commit. Fast. Deterministic. Almost impossible to misunderstand.

### Layer Two: Content Scanning

But filenames only tell part of the story.

Some of the worst leaks hide inside perfectly innocent files. A Terraform variable file. A JSON configuration. A YAML document. Even source code.

The filename doesn't look suspicious. The contents certainly are.

That's where Gitleaks enters the picture.

Instead of asking "What is this file called?" it asks a much more useful question: *"What is actually inside this file?"*

Those are completely different problems. So they deserve completely different solutions.

### Layer Three: GitHub Secret Scanning

Then comes the third layer. The one I hope never has to do any work.

Because no matter how much I like local tooling, I also know developers.

Sometimes someone commits with `--no-verify`. Sometimes they're using another machine. Sometimes a contributor isn't using my tooling at all. Sometimes life simply happens.

That's why the final line of defence doesn't live on my laptop.

It lives on GitHub.

Secret Scanning. Push Protection. One final opportunity to prevent a mistake from becoming a leak.

When people ask why I built three layers instead of one, the answer is actually quite boring.

Because every layer solves a different problem.

And because I've learned that security is much happier when it doesn't rely on a single hero.

---

## Automation Should Inform, Not Decide

One of the easiest mistakes you can make when building automation is assuming the software should always know better than the person using it.

I don't think that's true.

Automation is very good at spotting patterns.

Humans are still much better at understanding intent.

The first time I integrated Gitleaks into my workflow it immediately found… absolutely nothing interesting.

Or at least, nothing that I considered interesting.

One of my projects happened to contain the string `secondary=SSR`.

Perfectly harmless. Gitleaks saw something that looked suspicious enough to deserve a closer look. Technically, it wasn't wrong. It simply didn't have enough context.

I had two options.

I could weaken the scanner until it stopped complaining.

Or I could teach it something new.

I chose the second option. Instead of disabling rules, I added an allowlist entry to `.gitleaks.toml`. That small decision turned out to reflect something much bigger.

Good security tools shouldn't become quieter.

They should become smarter.

There's an important difference.

When `commit_gh` blocks one of my commits today, it doesn't just shout "No!" and leave me guessing. It tells me exactly what it found. Which file. Which line. Which rule.

From there, the decision is mine.

Maybe I've accidentally hardcoded a secret. I'll fix it. Maybe the file simply doesn't belong in Git. I'll add it to `.gitignore`. Maybe it's a genuine false positive. I'll teach the scanner about it.

Notice what's missing.

The tool never silently decides what should or shouldn't be ignored.

That choice stays with me.

I don't want automation making engineering decisions on my behalf. I want it making sure I don't overlook the obvious while I'm busy thinking about something else.

That's a partnership.

Not a replacement.

---

## Repositories Should Age Gracefully

One of the things I appreciate most about infrastructure as code is idempotency.

It's one of those words that sounds far more complicated than it really is.

In practice it simply means that you can safely run the same operation over and over again. If something already exists, nothing changes. If something is missing, it gets created.

Terraform works that way. Ansible works that way. Most mature infrastructure tooling works that way.

Somehow, repository management never seemed to catch up.

A lot of repository generators follow a "one and done" approach. They create everything on day one and then quietly disappear from your life forever.

That works… until it doesn't.

Repositories evolve. Standards evolve. Best practices evolve. The repository I created two years ago isn't the repository I would create today. Neither am I the engineer I was two years ago.

So why should my tooling assume that repositories never change?

That's the idea behind `commit_gh --harden`.

I didn't want another bootstrap command that only worked on brand-new projects. I wanted something I could confidently run against a repository I'd been maintaining for three years.

If a `README.md` already exists, leave it alone. If a `LICENSE` is already there, don't touch it. If the release workflow exists, great. If it doesn't, create it. If Gitleaks has already been configured, move on. If not, let's fix that.

That may sound like a small design decision, but it completely changes how you think about the tool.

It stops being a project initializer.

It becomes a repository maintenance tool.

More importantly, it becomes *safe*.

There's a certain comfort in knowing that I can revisit an old project on a Sunday afternoon, run one command, and quietly bring it up to today's standards without wondering what might break.

That's exactly the feeling I was aiming for.

---

## Confidence Is Better Than Memory

Something else happened while I was adding all these guardrails.

I stopped asking myself questions.

Questions like…

- *"Did I remember to add a LICENSE?"*
- *"Did I configure Dependabot?"*
- *"Did I enable Secret Scanning?"*
- *"Did I already create a release workflow?"*

Those questions simply disappeared. Not because I suddenly became more organized. Because the tooling had taken responsibility for checking instead of relying on me to remember.

That's why I eventually added another command.

`commit_gh --audit`

Originally it was nothing more than a quick verification script.

Today it has become something I run before publishing almost any repository.

Not because I expect something to be wrong.

Quite the opposite.

I expect everything to be right. The audit simply proves it.

When I run it, I don't really care about the individual green checkmarks.

I care about the feeling they create.

Confidence.

That might sound like a strange thing to optimize for. After all, it's just a repository.

But confidence compounds.

When I know my release workflow exists, I stop thinking about it. When I know Gitleaks is configured, I stop wondering. When I know Secret Scanning is enabled, I stop checking GitHub settings for the third time.

Every tiny decision my tooling makes on my behalf is one less thing occupying my working memory.

Individually they're insignificant.

Collectively they're enormous.

Software engineering isn't just about solving hard technical problems.

It's also about reducing unnecessary cognitive load.

That's where good tooling quietly pays for itself.

---

## Somewhere Along the Way It Stopped Being About Git

People occasionally ask me why I keep adding features to what started as a fairly small release helper.

It's a fair question.

On paper, `commit_gh` has grown far beyond its original purpose.

It initializes repositories. It creates GitHub repositories. It configures release workflows. It enables security features. It installs Gitleaks. It creates documentation. It audits repositories. It hardens older projects. It manages releases.

That's a lot of responsibility for a Bash script.

But I don't really see it that way.

I still think it's solving exactly the same problem it solved on day one.

Reducing friction.

The friction just moved.

A couple of years ago the friction lived in Git tags and semantic versioning. Today it lives in engineering consistency. Those are very different problems. The solution, however, is remarkably similar.

Find the repetitive work. Automate it. Repeat.

I suppose that's what `commit_gh` has really become.

Not a Git tool. Not a release tool. Not even a security tool.

It's simply a collection of engineering habits that I've stopped trusting myself to remember.

And honestly…

I'm perfectly okay with that.

---

## Repositories Are Infrastructure

This is probably the biggest lesson I didn't expect to learn while building `commit_gh`.

Repositories aren't just places where code lives.

They're infrastructure.

Infrastructure for developers.

We already have reusable Terraform modules. Golden machine images. Kubernetes bootstrap scripts. Platform engineering teams spend enormous amounts of time creating paved roads that help developers start from a secure, repeatable foundation.

Yet somehow, we often treat Git repositories as blank canvases.

I don't think they should be.

I think every repository deserves a secure baseline. Documentation. Ownership. Release automation. Dependency management. Security.

Not because every project needs every feature on day one.

But because adding those things later is almost always harder than having them from the beginning.

The first commit sets the tone for everything that follows.

Why not make it a good one?

---

## The Best Automation Is Quiet

One of my favourite things about `commit_gh` is that, on most days, I barely notice it's there.

It doesn't ask me dozens of questions. It doesn't try to become another platform. It doesn't insist that there's only one right way to build software.

Instead, it quietly nudges me towards the standards I've chosen for myself.

When I create a new repository, I don't have to remember to write a `README.md`. I don't have to wonder whether I enabled Dependabot. I don't have to check if Secret Scanning is turned on. I don't have to think about whether I already created a release workflow.

Those decisions have already been made.

The tool simply carries them out consistently.

That's probably my favourite definition of automation.

Not software that replaces engineers.

Software that allows engineers to spend less time remembering yesterday's checklist and more time solving tomorrow's problem.

---

## One Command — Everything Included

If any of this sounds familiar, getting started takes a single line.

```bash
curl -fsSL https://raw.githubusercontent.com/raymonepping/homebrew-commit-gh-cli/main/install.sh | bash
```

That one command handles everything:

- Installs Homebrew if it's not already there
- Taps the repository
- Installs or upgrades `commit-gh-cli`
- Checks whether `gitleaks` and the `gh` CLI are available, and tells you exactly how to install them if they're not
- Prints the three most useful getting-started commands so you know exactly where to begin

From there, the commands I reach for most:

```bash
# New repository — full scaffold, GitHub remote, and secret scanning in one step
commit_gh --init-repo --init-remote --public --secret-scanning

# Bring an existing repository up to standard
commit_gh --harden && commit_gh --audit

# Ship something
commit_gh --release patch
```

That's it.

No configuration files to write by hand. No checklist to remember. No second-guessing whether something got set up correctly.

The audit will tell you.

---

## Open by Default — Safe by Design

A few people asked me after yesterday's incident whether I was going to make all my repositories private from now on.

The answer surprised them.

No.

Most of my projects are intentionally public. I like sharing ideas. I like open source. I like people learning from my successes just as much as my mistakes.

Hiding everything behind private repositories doesn't really solve the problem.

It just changes who can see it.

The real goal isn't private repositories.

The real goal is repositories that are *safe to make public*.

That means documentation from day one. Ownership from day one. Release automation from day one. And security from day one.

Not because I expect to make mistakes.

Because I know I eventually will.

The difference is that now there are several layers quietly waiting to catch me before those mistakes become someone else's problem.

---

## Engineering Is Mostly About Tomorrow

There's a quote often attributed to Martin Fowler that I've always liked.

> *"Any fool can write code that a computer can understand. Good programmers write code that humans can understand."*

I think the same idea applies to repositories.

Anyone can create one. The interesting question is whether someone else — or perhaps even my future self — can confidently understand, maintain, release, and secure it six months from now.

That's the standard I've slowly found myself designing towards.

Not perfection. Repeatability.

Not complexity. Consistency.

Not clever automation. Thoughtful automation.

The kind that quietly fades into the background because it simply does the right thing.

---

## One Final Thought

Yesterday I leaked a secret.

Ironically, it lived in an `.env` file.

If today's version of `commit_gh` had existed a day earlier, that file would never have made it into a commit.

The filename check would have stopped me before Git even started. If I had somehow bypassed that, Gitleaks would have inspected the staged content. If I had bypassed that, GitHub Secret Scanning and Push Protection would still have had one final opportunity to stop me before the push reached the repository.

Three independent layers.

Three opportunities to catch one very human mistake.

That's exactly how I think good engineering should work.

Not by assuming people never make mistakes.

By assuming they eventually will.

And quietly being ready when they do.

---

When I first wrote `commit_gh`, I thought I was automating Git.

Looking back, I was automating the way I wanted to work.

Those turned out to be very different things.

The script will continue to evolve. New ideas will appear. Old assumptions will disappear. That's part of building software.

But one idea will probably remain.

The best engineering isn't about remembering more.

It's about needing to remember less.

Because the systems you've built are already looking after the things that matter.

---

If there's one thing yesterday reminded me of, it's this.

Every engineer carries a few scars.

The lucky ones learn from them.

The really lucky ones automate them away.

And honestly…

I think that's one of the most satisfying parts of this profession.
