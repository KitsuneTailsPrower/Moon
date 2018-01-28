--return
function c24.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(c24.cost)
	e1:SetTarget(c24.target)
	e1:SetOperation(c24.activate)
	c:RegisterEffect(e1)
end
function c24.cfilter(c)
	return c:IsSetCard(0x16F)
end
function c24.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c24.cfilter,1,nil) end
	local rg=Duel.SelectReleaseGroup(tp,c24.cfilter,1,1,nil)
	Duel.Release(rg,REASON_COST)
end
function c24.spfilter(c,e,tp)
	return  c:IsLevelBelow(3) and c:IsSetCard(0x16F) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c24.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=(e:GetLabel()==1)
		e:SetLabel(0)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return not Duel.IsPlayerAffectedByEffect(tp,59822133)
			and Duel.IsExistingMatchingCard(c24.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,2,nil,e,tp)
			and ((chkf and ft>0) or (not chkf and ft>1))
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_DECK)
	e:SetLabel(0)
end
function c24.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c24.spfilter),tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	if g:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,2,2,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
