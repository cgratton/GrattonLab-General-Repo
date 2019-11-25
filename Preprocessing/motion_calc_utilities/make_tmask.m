function tmask_fin = make_tmask(FD,FDthresh,DropFramesTR,contig_frames)

% first, make a simple FD mask
tmask = FD < FDthresh;

% from this mask, drop frames for the start scan effect
tmask(1:DropFramesTR) = 0;

% now remove frame segments that are too short
tmask_fin = sniptinymask(tmask,contig_frames);

tmask_fin = logical(tmask_fin);

end

function [mask2]=sniptinymask(mask1,snipsz)
% adapted from JDP, BA COHORT SELECT (WashU)

mask2 = mask1;

[chunksize startnums endnums] = maskgaps(~mask1);
goodsize=endnums-startnums+1;
goodlost=goodsize<snipsz;
for j=1:numel(goodlost)
    if goodlost(j)
        mask2(startnums(j):endnums(j))=0;
    end
end

end

function [chunksize startnums endnums] = maskgaps(mask)
% adapted from JDP, BA COHORT SELECT (WashU)
% presumes that mask is 1=keep, 0=discard


if nnz(mask)==0 % if all discarded
    chunksize=-numel(mask);
elseif nnz(mask)==numel(mask) % if all kept
    chunksize=numel(mask);
else % if some kept and some discarded
    
    dmask=diff(mask);
    numchunks=nnz(dmask)+1;
    chunksize=ones(numchunks,1);
    chunknum=1;
    
    for i=1:numel(dmask)
        if dmask(i)==0
            chunksize(chunknum,1)=chunksize(chunknum,1)+1;
        elseif dmask(i)==1
            chunksize(chunknum,1)=-chunksize(chunknum,1);
            chunknum=chunknum+1;
        elseif dmask(i)==-1
            chunknum=chunknum+1;
        end
        
        if i==numel(dmask)
            if chunksize(chunknum-1,1)>0
                chunksize(chunknum,1)=-chunksize(chunknum,1);
            end
        end
        
    end
end

if ~isequal((sum(abs(chunksize))),numel(mask))
    disp('error');
end

endnums=cumsum(abs(chunksize));
endnums=endnums(chunksize<0);
startnums=endnums+chunksize(chunksize<0)+1;


end