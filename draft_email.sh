#!/bin/bash
#
# Time-stamp: <Monday 2025-08-18 13:05:58 Jess Moore>
#
# Create a draft of an email in markdown
#
# Usage: draft_email.sh [args...]

function usage() {
    echo "Usage: draft_email recipient"
    echo ""
    echo "Description: Create a draft of an email in markdown."
    echo ""
    echo "Arguments:"
    echo "  recipient:  Name of recipient"
    echo ""
    exit 1 # Exit with a non-zero status to indicate an error
}

if [[ $# -eq 0 || $* == *"help"* || $* == *"-h"* ]]; then
    usage
fi

RECIPIENT=$1
SENDER=$(id -F)
NOW=$(date "+%A %Y-%m-%d %H:%M:%S")

## Form filename with syntax YYmmdd-draftEmailTo-person.md
# Convert recipient to lower Camel Case
PEOPLE_SUMM=$(echo "$RECIPIENT" | awk '{print tolower($0);}' | awk '{print $1, toupper(substr($2,1,1)) substr($2,2)}' | sed 's/ //g')

SENDER_FIRSTNAME=$(echo "$SENDER" | awk '{print $1}')

DATE_SUMM=$(date "+%Y%m%d")
# Form filename
FILENAME="${DATE_SUMM}-draftEmailTo-${PEOPLE_SUMM}.md"


cat > "${FILENAME}" << EOF
Cold email tips (Source: The Tim Ferris Show, 8/4/2026)

Subject: show your value, eg collaboration with Michelle Khare (XXXXX followers or XXXX views or collaborated with XYZ institutions)

Body:

*Three short paragraphs, each 2 sentences each.*

*Para 1, sentence 1: who you are, and your legitimacy. Just enough for the reader to see some value in what you are doing.*

*Para 1, sentence 2: what are you asking for or offering to the other person, and ideally you're offering something. In her eg, she is offering access to her audiences, in the eyes of many of their partners this is a marketing or recruitment opportunity for the partner.*

*Para 2, 2 sentences or less: on what you want to do. This is a window into the vision you hope to come to together. And a peak at some of the resources you might be asking for. Ideally you do it in such a way that you show that you've done your homework. That you're not just cold calling the FBI hoping to do a video with them. That you've watched everything you can online, about what does it take to do what they do in the academy. Its an opportunity to flatter them and to put them at ease.*

*Para 3, 2 sentences: the call to action.*

Eg. Hi X, 

My name is Michelle Khare. I am a content creator with this many followers, and I have done this, this and this. I am reaching out to enquire about an opportunity to film a collaboration for my channels.

We are hoping to do a shoot following just a few days of the FBI Academy, getting involved in existing activities, ultimately leading up to a final scene which would follow Academy protocols at that event.

I would love to hop on the phone. Let me know a good time. Here's my phone number 0432 632 505. Call me any time. 

Regards,

Eg.2. Hi X, 

My name is Jess Moore. I am a physics trained data scientist and Honorary Senior Fellow in the ANU School of Computing with a professional background in data analytics and data governance, who engineers secure privacy-first software on a basis of encryption and user ownership and control of their data. I am reaching out to enquire to discuss research interests in privacy, governance, trust, and fair data use in digital technology and data networks, to explore potential collaboration and whether my research interests might be a good fit with RegNet.

In the ANU Software Innovation Institute, I have been designing and developing secure privacy-first software using the new W3C Solid standard for web decentralisation and private data stores (global project https://solidproject.org, led by Sir Tim Berners Lee). The ANU SII team led by Prof Graham Williams have completed one project with an Australian Indigenous community in north Queensland, and has a second project, a medical research clinical trial with partners in Germany and medical researchers at ANU School of Medicine and Psychology. I can demonstrate a secure privacy-first app to improve equitable access to books in communities, one of our privacy-first apps, which with LLMs can be developed rapidly in days-weeks. Digital apps built on decentralised private data stores, allows every user to store data in their own private, portable, data store, in future enabling IP protection, data governance, and monetisation within secure private data sharing networks. It has potential application to challenges in market development, collaboration networks, and resource management that might tie in with RegNet's research in equity and governance in the Justice and TechnoScience Lab and the Extractive Systems Lab. I would like to discuss whether there is an opportunity to work with RegNet, and hopefully SoCy, to study the design and impact of digital tech on private decentralised data to better understand how to build the socio-technical system that ensures more equitable benefit in society. 

I would love to have a chat. Here's my phone number 0432 632 505. Call me any time. Or let me know a good time if you'd like to meet in person. 

Regards,



*From: ${SENDER}*

*To: ${RECIPIENT}*

**Subject: [ADD]**

*Date: ${NOW} ${SENDER}*

Hi [ADD]







Regards,
${SENDER_FIRSTNAME}

[ADD SIGNATURE]





<!-- markdownlint-disable-file MD009 MD012 MD013 MD029 MD036 MD041 -->
<!-- Ignores line length limit, no trailing spaces, multiple blanks, etc -->
EOF

echo "Done"
echo "Output: "
ls -l "$FILENAME"
