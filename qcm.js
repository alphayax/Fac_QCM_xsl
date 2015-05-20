function effaceReponses(Question)
{
  for (var i=0; i<Question.length-1; i++)
  {
    Question[i].checked = false;
  }
}