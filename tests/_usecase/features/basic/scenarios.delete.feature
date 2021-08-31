Feature: 리뷰 삭제 이벤트 처리 [REVIEW, DELETE]

Background: 리뷰 삭제 이벤트 처리를 위해서는 특정 장소와 유저, 수정할 리뷰글이 존재해야 함
    Given 아래와 같이 특정 장소가 등록되어 있음
        | placeId                              | country | name | bonusPoint | 
        | 2e4baf1c-5acb-4efb-a1af-eddada31b00f | 호주     | 멜번  | 1          |
    
    And 아래와 같이 특정 유저가 등록되어 있음
        | userId                               | name     | rewardPoint |
        | 3ede0ef2-92b7-4817-a5f3-0c575361f745 | Michael  | 3           |

    Given 유저가 아래와 같이 특정 장소에 대해 리뷰를 작성하여 포인트가 발급되었음
        | type   | action | reviewId                              | content | attachedPhotoIds                                                              | userId                               | placeId                              |
        | REVIEW | ADD    | 240a0658-dc5f-4878-9831-ebb7b26687772 | 좋아요    | e4d1a64e-a531-46de-88d0-ff0ed70c-c0bb8,afb0cef2-851d-4a50-bb07-9cc15cbdc332   | 3ede0ef2-92b7-4817-a5f3-0c575361f745 |  2e4baf1c-5acb-4efb-a1af-eddada31b00f|


Rule: 유저가 삭제한 글이 리뷰 리워드 대상일 경우, 최초에 부여했던 리뷰 포인트를 회수함

    Scenario: 사용자가 기존에 작성하였던 리뷰를 삭제함

        Given 유저의 과거 포인트 부여 기록이 아래와 같음
            | rewardId   | userId                                      | reviewId                              | operation | pointDelta | 
            | REVIEW     | 3ede0ef2-92b7-4817-a5f3-0c575361f745        | 240a0658-dc5f-4878-9831-ebb7b26687772 | ADD       | 3          | 

        When 유저가 아래와 같이 작성했던 리뷰를 삭제함
            | type   | action | reviewId                              | content | attachedPhotos | userId                               | placeId                              |
            | REVIEW | DELETE | 240a0658-dc5f-4878-9831-ebb7b26687772 |         |                | 3ede0ef2-92b7-4817-a5f3-0c575361f745 |  2e4baf1c-5acb-4efb-a1af-eddada31b00f|

        Then 유저의 포인트 총점이 아래와 같아짐
            | userId                                | totalPoint |
            | 3ede0ef2-92b7-4817-a5f3-0c575361f745  | 0          |
