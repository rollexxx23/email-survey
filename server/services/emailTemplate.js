
var redirectDomain = "http://localhost:5000" ;

module.exports = survey => {
  return `
  <html>
    <body>
      <div style="text-align: center;">
        <h3>Your input is required</h3>
        <p>Please answer the following question:</p>
        <p>${survey.body}</p>
        <div>
          <a href="${redirectDomain}/api/survey/${survey.id}/yes">Yes</a>
          <a href="${redirectDomain}/api/survey/${survey.id}/no">No</a>
        </div>
      </div>
    </body>
  </html>
  `;
};


