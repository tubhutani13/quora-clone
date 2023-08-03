class VoteHandler {
    constructor(container) {
      this.voteableContainer = container;
    }
  
    init() {
      this.voteableContainer.addEventListener('click', async event => {
        if (event.target.classList.contains('vote-button')) {
          event.preventDefault();
          const voteButton = event.target;
          const formData = this.generateDataForRequest(voteButton.form);
          const data = await this.handleVoteRequests(voteButton, formData);
  
          if (data.error) {
            this.handleError(data.error);
          } else {
            const {
              dataset: {
                resourceId,
                resourceType,
                buttonType
              }
            } = voteButton;
      
            this.handleVoteButtonClasses(voteButton, resourceId, resourceType, buttonType, data);
          }
        }
      });
    }
  
    generateDataForRequest(form) {
      const data = new URLSearchParams();
      for (const pair of new FormData(form)) {
          data.append(pair[0], pair[1]);
      }
      return data;
    }
  
    handleError(error) {
      const noticeElement = document.getElementById('notice');
      noticeElement.textContent = error;
      noticeElement.scrollIntoView();
    }
  
    handleVoteButtonClasses(voteButton, resourceId, resourceType, buttonType, data) {
      let currentAnswerVoteCount = document.getElementById(`vote-count-${resourceId}-${resourceType}`);
      currentAnswerVoteCount.textContent = data.total_votes;
  
      if (buttonType === 'upvote') {
        document.getElementById(`downvote-button-${resourceId}-${resourceType}`).classList.remove('downvote');
        voteButton.classList.toggle('upvote');
      } else {
        document.getElementById(`upvote-button-${resourceId}-${resourceType}`).classList.remove('upvote');
        voteButton.classList.toggle('downvote');
      }
    }
  
    async handleVoteRequests(voteButton, formData) {
      const res = await fetch(voteButton.form.action, {
        method: 'post',
        body: formData
      });
  
      return await res.json();
    }
  };
  
  const voteHandler = new VoteHandler(document.querySelector('[data-ref="voteable-container"]'));
  voteHandler.init();
  