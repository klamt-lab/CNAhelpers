function [mass_imbalanced_reacs, charge_imbalanced_reacs] = check_mass_balance(cnap)
% check mass balance of a stoichiometric model
%

%% 1. find exchange reactions, chemical formulas and occurring elements
    exchange_reacs = all(sign(cnap.stoichMat)<=0,1) | all(sign(cnap.stoichMat)>=0,1);
    chemFormula = CNAgetGenericSpeciesData_as_array(cnap,'fbc_chemicalFormula');
    if isempty(chemFormula)
        warning('field fbc_chemicalFormula not found. Trying to identify chemical formulas spec notes directly.');
        chemFormula = regexp(cnap.specNotes,'(?<=\[).*(?=\])','match');
        chemFormula = [chemFormula{:}]';
    end
    charge = cell2mat(CNAgetGenericSpeciesData_as_array(cnap,'fbc_charge'))';
    if isempty(charge)
        warning('field fbc_charge not found. Trying to identify charges from spec notes directly.');
        charge = regexp(cnap.specNotes,'(?<=<).*(?=>)','match');
        charge = cellfun(@str2num,[charge{:}]);
    end
    elements = regexp(chemFormula,'[A-Z][a-z]*','match');
    elements = unique([elements{:}]);
    % if no element counter was set, set a '1' after the element
    chemFormula = regexprep(chemFormula, ['(?<=[' strjoin(elements,'|') '])(?=[^a-z0-9]|$)'],'1','emptymatch');
%% 2. make a matrix with all species and their elements
    species_element_matrix = zeros(cnap.nums,numel(elements));
    for i = 1:numel(elements)
        elem_count = regexp(chemFormula, ['(?<=' elements{i} ')[0-9]*'],'match');
        elem_count(cellfun(@isempty,elem_count)) = {'0'};
        elem_count = cellfun(@str2num,[elem_count{:}]);
        species_element_matrix(:,i) = elem_count;
    end
%% 3. check if reactions are balanced
    disp('checking for reactions with mass imbalance...');
    mass_balances = cnap.stoichMat'*species_element_matrix;
    mass_imbalanced_reacs = find(any(abs(mass_balances)>1e-4,2) & ~exchange_reacs');
    mass_imbalance_table =  [{''}, elements;cellstr(cnap.reacID(mass_imbalanced_reacs,:)) num2cell(mass_balances(mass_imbalanced_reacs,:))];
    disp(['model has ' num2str(sum(any(abs(mass_balances)>1e-4,2) & exchange_reacs')) ' mass-imbalanced exchange reactions.'])
    disp(['model has ' num2str(numel(mass_imbalanced_reacs)) ' mass-imbalanced metabolic reactions:']);
    disp(cellstr(cnap.reacID(mass_imbalanced_reacs,:)));
    
    disp('checking for reactions with charge imbalance...');
    charge_balances = cnap.stoichMat'*charge';
    charge_imbalanced_reacs = find(any(abs(charge_balances)>1e-4,2) & ~exchange_reacs');
    charge_imbalance_table =  [{''}, {'charge'};cellstr(cnap.reacID(charge_imbalanced_reacs,:)) num2cell(charge_balances(charge_imbalanced_reacs,:))];
    disp(['model has ' num2str(sum(any(abs(charge_balances)>1e-4,2) & exchange_reacs')) ' charge-imbalanced exchange reactions.'])
    disp(['model has ' num2str(numel(charge_imbalanced_reacs)) ' charge-imbalanced metabolic reactions:']);
    disp(cellstr(cnap.reacID(charge_imbalanced_reacs,:)));
end

