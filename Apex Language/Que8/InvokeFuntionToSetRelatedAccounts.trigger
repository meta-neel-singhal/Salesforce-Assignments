trigger InvokeFuntionToSetRelatedAccounts on Opportunity (before update) {
	RelatedAccount relatedAccountObject = new RelatedAccount();
    relatedAccountObject.setRelatedAccounts(Trigger.new);
}